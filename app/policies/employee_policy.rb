# Company tab (People Directory, Add Employee, Employee Detail) is
# HR-Admin-only — see kos/decisions/ui/navigation-me-team-company.md.
class EmployeePolicy < ApplicationPolicy
  def index?
    user.admin?
  end

  def show?
    user.admin?
  end

  def create?
    user.admin?
  end

  def update?
    user.admin?
  end

  def schedule_offboarding?
    user.admin?
  end

  def mark_offboarded?
    user.admin?
  end

  class Scope < Scope
    def resolve
      scope.where(company: user.company)
    end
  end
end
