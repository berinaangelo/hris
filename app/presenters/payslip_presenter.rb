# View formatting for a payslip's line items, grouped by kind — kept
# out of the (skinny, persistence-only) Payslip model, per
# kos/decisions/rails-presenters-decorators-for-view-formatting.md.
#
# Reads off an already-loaded payslip_line_items association (no
# scopes here) so it doesn't re-query per payslip when the caller
# preloaded them — e.g. Payroll Run Detail's master table.
class PayslipPresenter
  # Friendly labels for line items with no free-text description — see
  # kos/decisions/ux-pages/my-payslips.html's breakdown rows.
  LINE_TYPE_LABELS = {
    "base_salary" => "Basic pay",
    "overtime" => "Overtime",
    "bonus" => "Bonus",
    "cash_advance" => "Cash advance repayment",
    "other_deduction" => "Other deduction",
    "loan_repayment" => "Loan amortization",
    "statutory_sss" => "SSS",
    "statutory_philhealth" => "PhilHealth",
    "statutory_pagibig" => "Pag-IBIG",
    "statutory_bir" => "BIR withholding tax",
    "thirteenth_month_pay" => "13th month pay"
  }.freeze

  def initialize(payslip)
    @payslip = payslip
  end

  # "Aug 1–15, 2026" — collapses the month when both dates share one.
  def period_label
    run = @payslip.payroll_run
    return "13th Month Pay" if run.thirteenth_month?

    start_date, end_date = run.period_start, run.period_end
    if start_date.month == end_date.month && start_date.year == end_date.year
      "#{start_date.strftime("%b %-d")}–#{end_date.strftime("%-d, %Y")}"
    else
      "#{start_date.strftime("%b %-d")} – #{end_date.strftime("%b %-d, %Y")}"
    end
  end

  def thirteenth_month?
    @payslip.payroll_run.thirteenth_month?
  end

  def line_item_label(item)
    item.description.presence || LINE_TYPE_LABELS.fetch(item.line_type, item.line_type.humanize)
  end

  def base_salary
    sum_for("base_salary")
  end

  def loan_deductions
    sum_for("loan_repayment")
  end

  # Net signed total of manually-added adjustments (bonus/overtime/cash
  # advance/other deduction) — earnings add, deductions subtract. Base
  # salary/loan/statutory are their own columns on Payroll Run Detail's
  # master table, so excluded here via source rather than by name.
  def adjustments_total
    line_items.select(&:manual?).sum { |item| item.earning? ? item.amount : -item.amount }
  end

  def statutory_deductions
    line_items.select { |item| item.line_type.start_with?("statutory_") }.sum(&:amount)
  end

  # Oldest → newest, for the Payslip Detail (admin) "Correction history"
  # rail. Walks previous_version back to the root, then reissued_version
  # forward — a chain is expected to stay short (one void & reissue at a
  # time), so this isn't eager-loading-optimized for arbitrary depth.
  def version_chain
    root = @payslip
    root = root.previous_version while root.previous_version

    chain = [ root ]
    chain << chain.last.reissued_version while chain.last.reissued_version
    chain
  end

  private

  def line_items
    @payslip.payslip_line_items
  end

  def sum_for(line_type)
    line_items.select { |item| item.line_type == line_type }.sum(&:amount)
  end
end
