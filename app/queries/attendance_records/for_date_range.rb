module AttendanceRecords
  # Reused by Team::AttendanceRecordsController#index. Scoping (admin
  # sees all, manager sees only direct reports) is delegated to
  # AttendanceRecordPolicy::Scope rather than duplicated here, per
  # kos/decisions/rails-query-objects-for-reused-queries.md.
  #
  # status/search narrow what's displayed in the table only — the caller
  # is expected to compute stat-strip counts from a separate call without
  # them, so the counts always reflect the full period regardless of the
  # active filter (see Team::AttendanceRecordsController#load_index_data).
  class ForDateRange
    def self.call(viewer:, start_date:, end_date:, status: nil, search: nil)
      scope = AttendanceRecordPolicy::Scope.new(viewer, AttendanceRecord).resolve
                .includes(:shift_template, employee: :manager)
                .where(date: start_date..end_date)
      scope = scope.where(status: status) if AttendanceRecord.statuses.key?(status)
      scope = filter_by_name(scope, search)
      scope.order(date: :desc, employee_id: :asc)
    end

    # OR-combo across two columns, hence Arel per
    # kos/decisions/rails-arel-for-complex-queries.md. .matches compiles to
    # a portable LIKE — correct here since this app runs on MySQL with a
    # case-insensitive (ai_ci) collation, not Postgres/ILIKE.
    def self.filter_by_name(scope, search)
      return scope if search.blank?

      employees = Employee.arel_table
      term = "%#{ActiveRecord::Base.sanitize_sql_like(search)}%"
      scope.joins(:employee).where(employees[:first_name].matches(term).or(employees[:last_name].matches(term)))
    end
  end
end
