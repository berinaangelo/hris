class AttendanceCorrectionRequestSubmittedNotifierJob < ApplicationJob
  def perform(correction_request)
    reviewer = correction_request.employee.manager
    return unless reviewer&.attendance_correction_updates_notifications

    AttendanceCorrectionRequestMailer.submitted_email(correction_request).deliver_now
  end
end
