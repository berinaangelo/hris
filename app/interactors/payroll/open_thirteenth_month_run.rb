module Payroll
  # Same transactional/idempotency shape as Payroll::OpenRun, gated by
  # the company's thirteenth_month_pay_enabled toggle instead of a
  # basic-salary presence check — the payout formula degrades to ₱0
  # gracefully for an employee with no payslip history yet, so there's
  # nothing to validate upfront the way regular runs need basic_salary.
  class OpenThirteenthMonthRun
    include Interactor

    def call
      company = context.company

      unless company.thirteenth_month_pay_enabled?
        context.fail!(message: "13th month pay is disabled for this company — enable it in Payroll Settings first.")
        return
      end

      if company.payroll_runs.open.exists?
        context.fail!(message: "A payroll run is already open — finalize it before opening another.")
        return
      end

      create_run_and_payslips(company)
    end

    private

    def create_run_and_payslips(company)
      ActiveRecord::Base.transaction do
        payroll_run = company.payroll_runs.create!(
          period_start: context.period_start,
          period_end: context.period_end,
          pay_date: context.pay_date,
          run_type: :thirteenth_month
        )

        Payroll::PayableEmployees.call(company).each do |employee|
          Payroll::GenerateThirteenthMonthPayslip.call!(employee: employee, payroll_run: payroll_run)
        end

        context.payroll_run = payroll_run
      end
    rescue ActiveRecord::RecordInvalid => e
      context.fail!(message: e.message)
    end
  end
end
