# Headless policy, same shape as TeamApprovalPolicy — Org Chart isn't
# scoped to one record, and Company tab is HR-Admin-only per
# kos/decisions/ui/navigation-me-team-company.md.
class OrgChartPolicy < ApplicationPolicy
  def show?
    user.admin?
  end
end
