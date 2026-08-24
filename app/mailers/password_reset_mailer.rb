class PasswordResetMailer < ApplicationMailer
  def reset_instructions(employee, token)
    @employee = employee
    @reset_url = edit_password_reset_url(token: token)

    mail(to: employee.work_email, subject: "Reset your HRIS password")
  end
end
