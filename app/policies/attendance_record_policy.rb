# Manager and admin have identical edit capability — this is not
# admin-only. Self-edit is never allowed, even for a manager/admin
# editing their own row: a punch record someone could silently rewrite
# for themselves isn't trustworthy, so they go through a correction
# request like anyone else. Gated by the company-wide
# attendance_manual_edit_enabled toggle rather than a role — see
# kos/decisions/time-attendance-correction-request-and-manual-edit.md.
class AttendanceRecordPolicy < ApplicationPolicy
  def index?
    user.manager? || user.admin?
  end

  def update?
    return false unless user.company.attendance_manual_edit_enabled
    return false if record.employee == user
    return false unless record.employee.company_id == user.company_id

    user.admin? || (user.manager? && record.employee.manager == user)
  end

  class Scope < Scope
    def resolve
      return scope.none unless user.manager? || user.admin?

      if user.admin?
        scope.joins(:employee).where(employees: { company_id: user.company_id })
      else
        scope.joins(:employee).where(employees: { manager_id: user.id })
      end
    end
  end
end
