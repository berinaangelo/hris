# Headless policy — Team Reviews' roster isn't scoped to one
# ReviewCycle record on #index (it's the manager's whole team, including
# direct reports with no cycle yet); per-cycle create/edit/publish
# checks stay on ReviewCyclePolicy. Mirrors TeamApprovalPolicy's shape.
class TeamReviewCyclePolicy < ApplicationPolicy
  def index?
    user.manager? || user.admin?
  end
end
