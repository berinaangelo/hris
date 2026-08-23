class LeaveRequestSubmittedNotifierJob < ApplicationJob
  def perform(leave_request)
    approver = leave_request.approver
    return unless approver&.leave_request_updates_notifications

    LeaveRequestMailer.submitted_email(leave_request).deliver_now
  end
end
