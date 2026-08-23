class LeaveDecisionNotifierJob < ApplicationJob
  def perform(leave_request)
    return unless leave_request.employee.leave_request_updates_notifications

    LeaveRequestMailer.decision_email(leave_request).deliver_now
  end
end
