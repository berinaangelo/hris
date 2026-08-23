class AttendanceCorrectionRequestPolicy < ApplicationPolicy
  def index?
    true
  end

  def create?
    true
  end

  def show?
    record.employee == user || approve?
  end

  # Single-level approval only, straight to the requester's manager —
  # see kos/decisions/approval-chains-scrapped-fallback-design.md
  def approve?
    return true if user.admin?

    user.manager? && record.employee.manager == user
  end

  def reject?
    approve?
  end

  class Scope < Scope
    def resolve
      scope.where(employee: user)
    end
  end
end
