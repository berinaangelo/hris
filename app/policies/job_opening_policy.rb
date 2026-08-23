# Company tab (Recruitment / Job Openings) is HR-Admin-only — see
# kos/decisions/ui/navigation-me-team-company.md.
class JobOpeningPolicy < ApplicationPolicy
  def index?
    user.admin?
  end

  def create?
    user.admin?
  end

  def update?
    user.admin? && record.company_id == user.company_id
  end

  def show?
    update?
  end

  class Scope < Scope
    def resolve
      return scope.none unless user.admin?

      scope.where(company_id: user.company_id)
    end
  end
end
