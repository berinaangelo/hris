# Company-wide policy setting (shift hours), unlike attendance records
# which are admin-or-manager — admin only. See
# kos/decisions/rails-pundit-for-authorization.md.
class ShiftTemplatePolicy < ApplicationPolicy
  def index?
    user.admin?
  end

  def create?
    user.admin?
  end

  def update?
    user.admin? && record.company_id == user.company_id
  end

  def destroy?
    update?
  end

  class Scope < Scope
    def resolve
      return scope.none unless user.admin?

      scope.where(company_id: user.company_id)
    end
  end
end
