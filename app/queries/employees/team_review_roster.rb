module Employees
  # Reused by Team::ReviewCyclesController#index. Returns Employee
  # records (not ReviewCycle records) so a direct report with no cycle
  # yet still appears on the roster as "Not started" — see
  # kos/decisions/schema/performance-reviews-schema.md.
  class TeamReviewRoster
    def self.call(manager:)
      manager.direct_reports.includes(review_cycles: :kpi_entries).order(:last_name, :first_name)
    end
  end
end
