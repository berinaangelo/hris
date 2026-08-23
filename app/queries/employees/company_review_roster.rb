module Employees
  # Reused by CompanyReviewCyclesController#index. Company-scoping
  # delegates to EmployeePolicy::Scope rather than duplicating it, per
  # kos/decisions/rails-query-objects-for-reused-queries.md. Returns
  # Employee records (not ReviewCycle records) so employees with no
  # cycle yet still appear on the roster as "Not started".
  #
  # The status filter runs in Ruby against ReviewStatusPresenter rather
  # than SQL, since "current status" is derived across cycle_type/
  # status/dates on an employee's *most recent* cycle, not a single
  # column — fine at SME headcount; would need a denormalized column to
  # move to SQL, which the schema doc explicitly defers until needed.
  class CompanyReviewRoster
    def self.call(viewer:, department: nil, status: nil, search: nil)
      scope = EmployeePolicy::Scope.new(viewer, Employee).resolve.active.includes(review_cycles: :kpi_entries)
      scope = scope.where(department: department) if department.present?
      scope = scope.where("first_name LIKE :q OR last_name LIKE :q", q: "%#{search}%") if search.present?

      employees = scope.sort_by { |employee| [ employee.last_name, employee.first_name ] }

      case status
      when "on_pip" then employees.select { |employee| ReviewStatusPresenter.new(employee).on_pip? }
      when "needs_scoring" then employees.select { |employee| ReviewStatusPresenter.new(employee).needs_scoring? }
      else employees
      end
    end
  end
end
