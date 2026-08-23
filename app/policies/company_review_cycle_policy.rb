# Company tab (Performance Reviews / "Company Reviews") is
# HR-Admin-only — see kos/decisions/ui/navigation-me-team-company.md.
# #show authorizes an Employee record (the per-employee detail page),
# not a ReviewCycle, mirroring EmployeePolicy's own show? shape.
class CompanyReviewCyclePolicy < ApplicationPolicy
  def index?
    user.admin?
  end

  def new?
    user.admin?
  end

  def create?
    user.admin?
  end

  def show?
    user.admin? && record.company_id == user.company_id
  end
end
