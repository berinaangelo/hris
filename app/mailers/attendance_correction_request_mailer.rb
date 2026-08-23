class AttendanceCorrectionRequestMailer < ApplicationMailer
  def submitted_email(correction_request)
    @correction_request = correction_request
    @employee = correction_request.employee
    @reviewer = correction_request.employee.manager

    mail(to: @reviewer.work_email, subject: "#{@employee.full_name} requested an attendance correction")
  end

  def decision_email(correction_request)
    @correction_request = correction_request
    @employee = correction_request.employee

    verb = correction_request.approved? ? "approved" : "rejected"
    mail(to: @employee.work_email, subject: "Your attendance correction request was #{verb}")
  end
end
