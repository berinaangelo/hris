module Payroll
  # "Only one run can be open at a time" is enforced here, in app logic
  # — not a DB constraint (MySQL has no partial/filtered unique index),
  # per kos/decisions/schema/payroll-v2-schema.md. Generates every
  # payable employee's draft payslip immediately on open, not deferred
  # to finalize.
  class OpenRun
    include Interactor

    def call
      company = context.company

      if company.payroll_runs.open.exists?
        context.fail!(message: "A payroll run is already open — finalize it before opening another.")
        return
      end

      employees = Payroll::PayableEmployees.call(company)
      missing_salary = employees.select { |employee| employee.basic_salary.blank? || employee.basic_salary <= 0 }

      if missing_salary.any?
        context.fail!(message: "Set a basic salary before opening a run — missing for #{missing_salary.map(&:full_name).to_sentence}.")
        return
      end

      create_run_and_payslips(company, employees)
    end

    private

    # .call! inside the transaction per
    # kos/decisions/rails-db-transactions-locking-idempotency.md — plain
    # .call wouldn't raise on a failed step, so the transaction wouldn't
    # roll back. Any ActiveRecord::RecordInvalid bubbling out of it is
    # re-raised as this interactor's own context.fail! so a plain
    # .call from the controller still gets a clean result.failure?.
    def create_run_and_payslips(company, employees)
      ActiveRecord::Base.transaction do
        payroll_run = company.payroll_runs.create!(
          period_start: context.period_start,
          period_end: context.period_end,
          pay_date: context.pay_date,
          run_type: :regular
        )

        employees.each do |employee|
          Payroll::GeneratePayslip.call!(employee: employee, payroll_run: payroll_run)
        end

        context.payroll_run = payroll_run
      end
    rescue ActiveRecord::RecordInvalid => e
      context.fail!(message: e.message)
    end
  end
end
