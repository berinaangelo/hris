# Headless policy — Reports isn't scoped to one record. Mirrors
# TeamApprovalPolicy/CompanyReviewCyclePolicy's headless shape. Company
# tab, HR-Admin-only — see kos/decisions/ui/navigation-me-team-company.md
# and kos/decisions/ui/reports-landing-grid-drill-in.md.
class ReportPolicy < ApplicationPolicy
  def index?
    user.admin?
  end

  def show?
    user.admin?
  end
end
