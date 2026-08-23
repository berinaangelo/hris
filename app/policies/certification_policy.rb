# Compliance/Certifications (Company tab) is HR-Admin-only — see
# kos/decisions/ui/navigation-me-team-company.md.
class CertificationPolicy < ApplicationPolicy
  def index?
    user.admin?
  end

  def create?
    user.admin?
  end

  def update?
    user.admin? && record.employee.company_id == user.company_id
  end

  def destroy?
    update?
  end

  class Scope < Scope
    def resolve
      return scope.none unless user.admin?

      scope.joins(:employee).where(employees: { company_id: user.company_id })
    end
  end
end
