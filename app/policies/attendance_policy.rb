# Headless policy — clock-in/clock-out always acts on current_employee's
# own record, no id/record to authorize against, same shape as
# TeamApprovalPolicy for the approvals inbox.
class AttendancePolicy < ApplicationPolicy
  def clock_in?
    true
  end

  def clock_out?
    true
  end
end
