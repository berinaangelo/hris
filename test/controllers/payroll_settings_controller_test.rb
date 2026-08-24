require "test_helper"

class PayrollSettingsControllerTest < ActionDispatch::IntegrationTest
  test "admin can view payroll settings" do
    sign_in employees(:admin_amy)

    get payroll_settings_path

    assert_response :success
  end

  test "admin can toggle 13th month pay" do
    sign_in employees(:admin_amy)

    patch payroll_settings_path, params: { company: { thirteenth_month_pay_enabled: false } }

    assert_redirected_to payroll_settings_path
    assert_not companies(:acme).reload.thirteenth_month_pay_enabled?
  end

  test "manager is forbidden" do
    sign_in employees(:manager_jane)

    get payroll_settings_path
    assert_redirected_to root_path

    patch payroll_settings_path, params: { company: { thirteenth_month_pay_enabled: false } }
    assert_redirected_to root_path
  end

  test "plain employee is forbidden" do
    sign_in employees(:worker_bob)

    get payroll_settings_path

    assert_redirected_to root_path
  end

  private

  def sign_in(employee)
    post session_path, params: { work_email: employee.work_email, password: "password" }
  end
end
