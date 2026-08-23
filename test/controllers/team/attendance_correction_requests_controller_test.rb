require "test_helper"

module Team
  class AttendanceCorrectionRequestsControllerTest < ActionDispatch::IntegrationTest
    test "manager can approve their direct report's pending request" do
      sign_in employees(:manager_jane)
      correction_request = attendance_correction_requests(:bob_pending)

      patch approve_team_attendance_correction_request_path(correction_request)

      assert_redirected_to team_attendance_correction_requests_path
      assert correction_request.reload.approved?
    end

    test "manager can reject their direct report's pending request" do
      sign_in employees(:manager_jane)
      correction_request = attendance_correction_requests(:bob_pending)

      patch reject_team_attendance_correction_request_path(correction_request)

      assert_redirected_to team_attendance_correction_requests_path
      assert correction_request.reload.rejected?
    end

    test "a manager who isn't the employee's manager is forbidden" do
      sign_in employees(:manager_optout)
      correction_request = attendance_correction_requests(:bob_pending)

      patch approve_team_attendance_correction_request_path(correction_request)

      assert_redirected_to root_path
      assert correction_request.reload.pending?
    end

    test "admin can approve any pending request" do
      sign_in employees(:admin_amy)
      correction_request = attendance_correction_requests(:bob_pending)

      patch approve_team_attendance_correction_request_path(correction_request)

      assert correction_request.reload.approved?
    end

    private

    def sign_in(employee)
      post session_path, params: { work_email: employee.work_email, password: "password" }
    end
  end
end
