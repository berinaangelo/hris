require "test_helper"

class DashboardControllerTest < ActionDispatch::IntegrationTest
  test "manager sees the pending-corrections card for their own reports' requests" do
    sign_in employees(:manager_jane)

    get root_path

    assert_response :success
    assert_select "a[href=?]", team_attendance_records_path, text: "Review now"
  end

  test "admin sees the pending-corrections card for company-wide requests" do
    sign_in employees(:admin_amy)

    get root_path

    assert_response :success
    assert_select "a[href=?]", team_attendance_records_path, text: "Review now"
  end

  test "a manager with no pending reports' requests doesn't see the card" do
    sign_in employees(:manager_optout)
    attendance_correction_requests(:request_to_optout_manager).update!(status: :approved)

    get root_path

    assert_response :success
    assert_select "a[href=?]", team_attendance_records_path, text: "Review now", count: 0
  end

  test "a plain employee never sees the card" do
    sign_in employees(:worker_bob)

    get root_path

    assert_response :success
    assert_select "a[href=?]", team_attendance_records_path, text: "Review now", count: 0
  end

  private

  def sign_in(employee)
    post session_path, params: { work_email: employee.work_email, password: "password" }
  end
end
