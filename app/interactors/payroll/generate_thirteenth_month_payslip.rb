module Payroll
  # 13th month pay is legally exempt from SSS/PhilHealth/Pag-IBIG
  # entirely, and BIR-exempt up to ₱90,000 — comfortably covering
  # typical SME payouts — so this models it as one earning line item,
  # no deductions layered on top, per
  # kos/decisions/thirteenth-month-pay-mandatory-in-ph.md's own
  # "trivial formula" framing.
  class GenerateThirteenthMonthPayslip
    include Interactor

    def call
      employee = context.employee
      payroll_run = context.payroll_run

      payslip = employee.payslips.create!(payroll_run: payroll_run, status: :draft)
      add_thirteenth_month_pay(payslip, employee)
      Payroll::RecomputePayslipTotals.call!(payslip: payslip)

      context.payslip = payslip
    end

    private

    # "Total basic salary earned in the year ÷ 12" — summed straight
    # off this employee's own finalized regular payslips, which
    # naturally prorates a mid-year hire (fewer payslips = smaller
    # total) without any separate tracking. A voided payslip's line
    # items don't count — only its reissue does, since the voided one
    # was superseded.
    def add_thirteenth_month_pay(payslip, employee)
      annual_base_earned = PayslipLineItem
        .joins(payslip: :payroll_run)
        .where(line_type: :base_salary, payslips: { employee: employee, status: :finalized })
        .where(payroll_runs: { period_start: Date.current.beginning_of_year..Date.current.end_of_year })
        .sum(:amount)

      amount = (annual_base_earned / 12).round(2)
      return unless amount.positive?

      payslip.payslip_line_items.create!(
        line_type: :thirteenth_month_pay, direction: :earning, source: :base, amount: amount
      )
    end
  end
end
