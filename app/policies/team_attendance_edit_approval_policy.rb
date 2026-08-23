# Headless policy for the sign-off inbox — admin-only, unlike
# TeamApprovalPolicy/AttendanceCorrectionRequestPolicy's index? which
# both allow manager or admin (sign-off itself is admin-only, see
# AttendanceRecordPolicy#approve_edit?).
class TeamAttendanceEditApprovalPolicy < ApplicationPolicy
  def index?
    user.admin?
  end
end
