class LeaveRequestMailer < ApplicationMailer
  def submitted_email(leave_request)
    @leave_request = leave_request
    @employee = leave_request.employee
    @approver = leave_request.approver

    mail(to: @approver.work_email, subject: "#{@employee.full_name} requested time off")
  end

  def decision_email(leave_request)
    @leave_request = leave_request
    @employee = leave_request.employee

    verb = leave_request.approved? ? "approved" : "rejected"
    mail(to: @employee.work_email, subject: "Your time off request was #{verb}")
  end
end
