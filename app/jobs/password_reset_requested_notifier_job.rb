class PasswordResetRequestedNotifierJob < ApplicationJob
  def perform(employee, token)
    PasswordResetMailer.reset_instructions(employee, token).deliver_now
  end
end
