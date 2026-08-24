module Payroll
  # The per-employee unit of payroll — base salary + active loan
  # deductions + statutory lookups → one draft Payslip. Reused by
  # Payroll::OpenRun for every active employee; a future 13th-month
  # generator can reuse it too.
  #
  # Manual adjustment line items (bonus/OT/cash advance/other deduction)
  # are out of scope this pass — see
  # kos/projects/hris/features/payroll-v2/PLAN.md.
  class GeneratePayslip
    include Interactor

    def call
      employee = context.employee
      payroll_run = context.payroll_run

      payslip = employee.payslips.create!(payroll_run: payroll_run, status: :draft)

      add_base_salary(payslip, employee)
      add_loan_deductions(payslip, employee)
      add_statutory_deductions(payslip, employee)
      total_up(payslip)

      context.payslip = payslip
    end

    private

    # Single pay period/cutoff schedule — semi-monthly, PH standard —
    # so monthly basic salary is prorated in half per cutoff.
    def add_base_salary(payslip, employee)
      base_pay = (employee.basic_salary / 2).round(2)
      payslip.payslip_line_items.create!(
        line_type: :base_salary, direction: :earning, source: :base, amount: base_pay
      )
    end

    def add_loan_deductions(payslip, employee)
      employee.loans.active.each do |loan|
        payslip.payslip_line_items.create!(
          line_type: :loan_repayment, direction: :deduction, source: :loan,
          loan: loan, amount: loan.monthly_amortization
        )
      end
    end

    def add_statutory_deductions(payslip, employee)
      base_pay = payslip.payslip_line_items.base_salary.sum(:amount)

      employee.company.rate_tables.each do |rate_table|
        deduction = Payroll::StatutoryDeductionCalculator.call(rate_table: rate_table, gross: base_pay).round(2)
        next if deduction <= 0

        payslip.payslip_line_items.create!(
          line_type: "statutory_#{rate_table.agency}", direction: :deduction, source: :statutory, amount: deduction
        )
      end
    end

    def total_up(payslip)
      earnings = payslip.payslip_line_items.earning.sum(:amount)
      deductions = payslip.payslip_line_items.deduction.sum(:amount)
      payslip.update!(gross_pay: earnings, total_deductions: deductions, net_pay: earnings - deductions)
    end
  end
end
