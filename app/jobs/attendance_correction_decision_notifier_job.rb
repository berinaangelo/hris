class AttendanceCorrectionDecisionNotifierJob < ApplicationJob
  def perform(correction_request)
    return unless correction_request.employee.attendance_correction_updates_notifications

    AttendanceCorrectionRequestMailer.decision_email(correction_request).deliver_now
  end
end
