require "test_helper"

class AttendanceCorrectionRequestsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in employees(:worker_bob)
  end

  test "index lists only the current employee's own requests" do
    get attendance_correction_requests_path

    assert_response :success
    assert_match attendance_correction_requests(:bob_pending).date.to_s, response.body
  end

  test "create submits a correction request and redirects" do
    assert_difference "AttendanceCorrectionRequest.count", 1 do
      post attendance_correction_requests_path, params: {
        attendance_correction_request: {
          date: "2026-08-25",
          requested_clock_in_at: "2026-08-25T09:00",
          reason: "Badge reader was broken"
        }
      }
    end

    assert_redirected_to attendance_correction_requests_path
  end

  test "create re-renders the form when invalid" do
    assert_no_difference "AttendanceCorrectionRequest.count" do
      post attendance_correction_requests_path, params: {
        attendance_correction_request: { date: "2026-08-25", reason: "" }
      }
    end

    assert_response :unprocessable_entity
  end

  private

  def sign_in(employee)
    post session_path, params: { work_email: employee.work_email, password: "password" }
  end
end
