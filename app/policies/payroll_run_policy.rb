# Payroll (Company tab) is HR-Admin-only — see
# kos/decisions/ui/payroll-runs-pinned-open-run.md.
class PayrollRunPolicy < ApplicationPolicy
  def index?
    user.admin?
  end

  def create?
    user.admin?
  end

  def show?
    user.admin? && record.company_id == user.company_id
  end

  def finalize?
    show?
  end

  class Scope < Scope
    def resolve
      return scope.none unless user.admin?

      scope.where(company_id: user.company_id)
    end
  end
end
