require "test_helper"

class OrgChartControllerTest < ActionDispatch::IntegrationTest
  test "admin sees each employee node linking to their Employee Detail page" do
    sign_in employees(:admin_amy)

    get org_chart_path

    assert_response :success
    assert_select "a[href=?]", employee_path(employees(:worker_bob))
    assert_select "a[href=?]", employee_path(employees(:manager_jane))
  end

  test "a manager is forbidden from viewing the org chart" do
    sign_in employees(:manager_jane)

    get org_chart_path

    assert_redirected_to root_path
  end

  test "a plain employee is forbidden from viewing the org chart" do
    sign_in employees(:worker_bob)

    get org_chart_path

    assert_redirected_to root_path
  end

  private

  def sign_in(employee)
    post session_path, params: { work_email: employee.work_email, password: "password" }
  end
end
