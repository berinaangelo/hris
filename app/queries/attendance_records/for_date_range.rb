module AttendanceRecords
  # Reused by Team::AttendanceRecordsController#index. Scoping (admin
  # sees all, manager sees only direct reports) is delegated to
  # AttendanceRecordPolicy::Scope rather than duplicated here, per
  # kos/decisions/rails-query-objects-for-reused-queries.md.
  class ForDateRange
    def self.call(viewer:, start_date:, end_date:)
      scope = AttendanceRecordPolicy::Scope.new(viewer, AttendanceRecord).resolve
      scope.includes(employee: :manager).where(date: start_date..end_date).order(date: :desc, employee_id: :asc)
    end
  end
end
