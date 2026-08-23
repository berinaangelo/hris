module LeaveRequests
  # Reused by Team::ApprovalsController's inbox and by the nav badge
  # count (a live query, not a stored table — see
  # kos/decisions/ui/notifications-nav-badge-counts.md), per
  # kos/decisions/rails-query-objects-for-reused-queries.md.
  class PendingForApprover
    def self.call(approver)
      return LeaveRequest.none unless approver.manager? || approver.admin?

      scope = LeaveRequest.pending.includes(:employee, :leave_type)
      approver.admin? ? scope : scope.where(approver: approver)
    end
  end
end
