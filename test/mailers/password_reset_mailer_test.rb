require "test_helper"

class PasswordResetMailerTest < ActionMailer::TestCase
  include Rails.application.routes.url_helpers

  test "reset_instructions goes to the employee's work email with a working link" do
    employee = employees(:worker_bob)
    token = employee.generate_token_for(:password_reset)

    email = PasswordResetMailer.reset_instructions(employee, token)

    assert_equal [ employee.work_email ], email.to
    assert_match "Reset your", email.subject
    assert_match edit_password_reset_url(token: token, host: "example.com"), email.body.to_s
  end
end
