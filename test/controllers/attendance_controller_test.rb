require "test_helper"

class AttendanceControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in employees(:worker_carol)
  end

  test "clock_in redirects with a notice" do
    post clock_in_attendance_path

    assert_redirected_to root_path
    assert_equal "Clocked in.", flash[:notice]
  end

  test "clock_in twice redirects with an alert the second time" do
    post clock_in_attendance_path
    post clock_in_attendance_path

    assert_redirected_to root_path
    assert_equal "You've already clocked in today.", flash[:alert]
  end

  test "clock_out without clocking in first redirects with an alert" do
    patch clock_out_attendance_path

    assert_redirected_to root_path
    assert_equal "Clock in first.", flash[:alert]
  end

  test "clock_out after clocking in redirects with a notice" do
    post clock_in_attendance_path
    patch clock_out_attendance_path

    assert_redirected_to root_path
    assert_equal "Clocked out.", flash[:notice]
  end

  private

  def sign_in(employee)
    post session_path, params: { work_email: employee.work_email, password: "password" }
  end
end
