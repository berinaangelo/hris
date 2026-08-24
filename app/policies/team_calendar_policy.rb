# Headless policy — Team Calendar isn't scoped to one record, same
# shape as TeamApprovalPolicy. See
# kos/decisions/ui/team-calendar-week-agenda.md.
class TeamCalendarPolicy < ApplicationPolicy
  def show?
    user.manager? || user.admin?
  end
end
