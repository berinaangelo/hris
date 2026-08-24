require "test_helper"

class PasswordResetRequestedNotifierJobTest < ActiveJob::TestCase
  include ActionMailer::TestHelper

  test "delivers the reset email" do
    employee = employees(:worker_bob)
    token = employee.generate_token_for(:password_reset)

    assert_emails 1 do
      PasswordResetRequestedNotifierJob.perform_now(employee, token)
    end
  end
end
