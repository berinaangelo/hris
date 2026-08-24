# Headless policy — company payroll settings aren't a single AR record
# to authorize against, mirroring AttendanceSettingsPolicy's pattern.
class PayrollSettingsPolicy < ApplicationPolicy
  def show?
    user.admin?
  end

  def update?
    user.admin?
  end
end
