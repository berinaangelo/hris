# View formatting for a payslip's line items, grouped by kind — kept
# out of the (skinny, persistence-only) Payslip model, per
# kos/decisions/rails-presenters-decorators-for-view-formatting.md.
#
# Reads off an already-loaded payslip_line_items association (no
# scopes here) so it doesn't re-query per payslip when the caller
# preloaded them — e.g. Payroll Run Detail's master table.
class PayslipPresenter
  def initialize(payslip)
    @payslip = payslip
  end

  def base_salary
    sum_for("base_salary")
  end

  def loan_deductions
    sum_for("loan_repayment")
  end

  def statutory_deductions
    line_items.select { |item| item.line_type.start_with?("statutory_") }.sum(&:amount)
  end

  private

  def line_items
    @payslip.payslip_line_items
  end

  def sum_for(line_type)
    line_items.select { |item| item.line_type == line_type }.sum(&:amount)
  end
end
