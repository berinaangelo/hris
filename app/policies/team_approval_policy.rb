# Headless policy — the Approvals inbox isn't scoped to one record, so
# there's no LeaveRequest to authorize against on #index (per-request
# approve?/reject? checks stay on LeaveRequestPolicy). Still goes
# through Pundit rather than an inline role check, per
# kos/decisions/rails-pundit-for-authorization.md.
class TeamApprovalPolicy < ApplicationPolicy
  def index?
    user.manager? || user.admin?
  end
end
