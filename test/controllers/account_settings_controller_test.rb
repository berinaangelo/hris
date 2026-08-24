require "test_helper"

class AccountSettingsControllerTest < ActionDispatch::IntegrationTest
  test "show renders the summary and notification preferences" do
    sign_in employees(:worker_bob)

    get account_settings_path

    assert_response :success
    assert_select "h2", text: employees(:worker_bob).full_name
    assert_select "[data-modal-open-value=?]", "false"
  end

  test "update toggles a single notification preference and redirects back" do
    employee = employees(:worker_bob)
    sign_in employee

    patch account_settings_path, params: { employee: { new_payslip_notifications: "0" } }

    assert_redirected_to account_settings_path
    assert_not employee.reload.new_payslip_notifications
  end

  private

  def sign_in(employee)
    post session_path, params: { work_email: employee.work_email, password: "password" }
  end
end
