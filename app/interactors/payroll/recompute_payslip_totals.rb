module Payroll
  # Shared by Payroll::GeneratePayslip (initial generation) and any
  # manual line-item edit on a draft payslip (Payslips::LineItemsController,
  # Payroll::VoidAndReissuePayslip's copied-forward lines) — one place
  # that turns a payslip's current line items into its stored totals.
  class RecomputePayslipTotals
    include Interactor

    def call
      payslip = context.payslip

      earnings = payslip.payslip_line_items.earning.sum(:amount)
      deductions = payslip.payslip_line_items.deduction.sum(:amount)
      payslip.update!(gross_pay: earnings, total_deductions: deductions, net_pay: earnings - deductions)
    end
  end
end
