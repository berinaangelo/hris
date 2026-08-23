class AttendanceEditDecisionNotifierJob < ApplicationJob
  def perform(attendance_record)
    editor = attendance_record.edited_by
    return unless editor&.attendance_edit_approval_notifications

    AttendanceEditApprovalMailer.decision_email(attendance_record).deliver_now
  end
end
