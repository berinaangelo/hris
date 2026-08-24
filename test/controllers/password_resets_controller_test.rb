require "test_helper"

class PasswordResetsControllerTest < ActionDispatch::IntegrationTest
  include ActiveJob::TestHelper

  test "new renders the request form" do
    get new_password_reset_path

    assert_response :success
    assert_select "input[name=?]", "work_email"
  end

  test "create with a known email queues the reset email and shows the sent confirmation" do
    employee = employees(:worker_bob)

    assert_enqueued_with(job: PasswordResetRequestedNotifierJob) do
      post password_resets_path, params: { work_email: employee.work_email }
    end

    assert_response :success
    assert_select "h3", text: "Check your email"
  end

  test "create with an unknown email shows the same sent confirmation — no account enumeration" do
    assert_no_enqueued_jobs do
      post password_resets_path, params: { work_email: "nobody@example.com" }
    end

    assert_response :success
    assert_select "h3", text: "Check your email"
  end

  test "create with a malformed email shows an inline format error, not a sent confirmation" do
    assert_no_enqueued_jobs do
      post password_resets_path, params: { work_email: "not-an-email" }
    end

    assert_response :unprocessable_entity
    assert_select ".field-error", text: "Enter a valid work email address."
  end

  test "edit with a valid token renders the reset form" do
    employee = employees(:worker_bob)
    token = employee.generate_token_for(:password_reset)

    get edit_password_reset_path(token: token)

    assert_response :success
    assert_select "input[name=?]", "new_password"
  end

  test "edit with an invalid token shows the expired panel" do
    get edit_password_reset_path(token: "not-a-real-token")

    assert_response :success
    assert_select "h3", text: "This link has expired"
  end

  test "update with matching passwords sets the new password and shows success" do
    employee = employees(:worker_bob)
    token = employee.generate_token_for(:password_reset)

    patch password_reset_path(token: token), params: { new_password: "a-new-password", new_password_confirmation: "a-new-password" }

    assert_response :success
    assert_select "h3", text: "Password updated"
    assert employee.reload.authenticate("a-new-password")
  end

  test "update with mismatched confirmation shows an inline error and doesn't change the password" do
    employee = employees(:worker_bob)
    token = employee.generate_token_for(:password_reset)

    patch password_reset_path(token: token), params: { new_password: "a-new-password", new_password_confirmation: "does-not-match" }

    assert_response :unprocessable_entity
    assert_select ".field-error", text: "Passwords don't match."
    assert_not employee.reload.authenticate("a-new-password")
  end

  test "update with an expired token shows the expired panel" do
    employee = employees(:worker_bob)
    token = employee.generate_token_for(:password_reset)

    travel 16.minutes do
      patch password_reset_path(token: token), params: { new_password: "a-new-password", new_password_confirmation: "a-new-password" }
    end

    assert_response :success
    assert_select "h3", text: "This link has expired"
  end
end
