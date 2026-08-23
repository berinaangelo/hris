module AttendanceCorrectionRequests
  # Reused by Team::AttendanceCorrectionRequestsController's inbox and by
  # the nav badge count (a live query, not a stored table — see
  # kos/decisions/ui/notifications-nav-badge-counts.md), per
  # kos/decisions/rails-query-objects-for-reused-queries.md.
  #
  # Unlike LeaveRequest there's no stored approver_id column — "who can
  # review" is resolved live off employee.manager, so the non-admin case
  # joins through employees instead of filtering a stored column.
  class PendingForApprover
    def self.call(approver)
      return AttendanceCorrectionRequest.none unless approver.manager? || approver.admin?

      scope = AttendanceCorrectionRequest.pending.includes(:employee, :attendance_record)
      approver.admin? ? scope : scope.joins(:employee).where(employees: { manager_id: approver.id })
    end
  end
end
