# Headless policy — company attendance settings aren't a single AR
# record to authorize against, mirroring TeamApprovalPolicy's pattern
# rather than an inline role check, per
# kos/decisions/rails-pundit-for-authorization.md.
class AttendanceSettingsPolicy < ApplicationPolicy
  def update?
    user.admin?
  end
end
