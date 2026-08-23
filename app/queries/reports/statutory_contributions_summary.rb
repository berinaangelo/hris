module Reports
  # Company-wide only, no department filter — per
  # kos/decisions/ui/reports-landing-grid-drill-in.md.
  class StatutoryContributionsSummary
    STATUTORY_TYPES = %w[statutory_sss statutory_philhealth statutory_pagibig statutory_bir].freeze

    def self.call(viewer:, payroll_run_id:)
      PayslipLineItem.joins(payslip: :payroll_run)
                      .where(payroll_runs: { id: payroll_run_id, company_id: viewer.company_id }, line_type: STATUTORY_TYPES)
                      .group(:line_type).order(:line_type).sum(:amount)
                      .map { |line_type, amount| { contribution: line_type.humanize, amount: amount } }
    end
  end
end
