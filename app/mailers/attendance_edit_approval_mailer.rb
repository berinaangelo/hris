class AttendanceEditApprovalMailer < ApplicationMailer
  def decision_email(attendance_record)
    @attendance_record = attendance_record
    @editor = attendance_record.edited_by

    verb = attendance_record.edit_approval_approved? ? "approved" : "rejected"
    mail(to: @editor.work_email, subject: "Your attendance edit for #{@attendance_record.employee.full_name} was #{verb}")
  end
end
