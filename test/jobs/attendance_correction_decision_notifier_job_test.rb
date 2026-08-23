require "test_helper"

class AttendanceCorrectionDecisionNotifierJobTest < ActiveJob::TestCase
  include ActionMailer::TestHelper

  test "delivers to the employee when they have notifications on" do
    correction_request = attendance_correction_requests(:bob_pending)
    correction_request.update!(status: :approved, reviewed_at: Time.current)

    assert_emails 1 do
      AttendanceCorrectionDecisionNotifierJob.perform_now(correction_request)
    end
  end

  test "no-ops when the employee opted out of notifications" do
    correction_request = attendance_correction_requests(:optout_employee_pending)
    correction_request.update!(status: :rejected, reviewed_at: Time.current)

    assert_emails 0 do
      AttendanceCorrectionDecisionNotifierJob.perform_now(correction_request)
    end
  end
end
