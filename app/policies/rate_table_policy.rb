# Rate Tables (Company → Payroll → Rate Tables) is HR-Admin-only — see
# kos/decisions/ui/rate-tables-landing-cards-edit-drawer.md.
class RateTablePolicy < ApplicationPolicy
  def index?
    user.admin?
  end

  def update?
    user.admin? && record.company_id == user.company_id
  end

  class Scope < Scope
    def resolve
      return scope.none unless user.admin?

      scope.where(company_id: user.company_id)
    end
  end
end
