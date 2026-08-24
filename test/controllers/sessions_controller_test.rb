require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "signing in without remember_me does not set a persistent cookie" do
    sign_in employees(:worker_bob)

    assert_nil cookies["employee_id"]
  end

  test "signing in with remember_me sets a persistent cookie and survives a dropped session" do
    sign_in employees(:worker_bob), remember_me: true
    assert_not_nil cookies["employee_id"]

    # Simulate the browser being closed and reopened: drop the Rails
    # session cookie, keep everything else.
    cookies.delete(Rails.application.config.session_options[:key])

    get my_profile_path

    assert_response :success
  end

  test "signing out clears the remember-me cookie" do
    sign_in employees(:worker_bob), remember_me: true
    assert_not_nil cookies["employee_id"]

    delete session_path

    assert cookies["employee_id"].blank?
  end

  test "a failed login shows an inline error and does not set a session" do
    post session_path, params: { work_email: employees(:worker_bob).work_email, password: "wrong" }

    assert_response :unprocessable_entity
    assert_select ".field-error", text: "Incorrect email or password."
  end

  private

  def sign_in(employee, remember_me: false)
    post session_path, params: { work_email: employee.work_email, password: "password", remember_me: (remember_me ? "1" : "0") }
  end
end
