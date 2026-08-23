require "test_helper"

class AttendanceCorrectionRequestSubmittedNotifierJobTest < ActiveJob::TestCase
  include ActionMailer::TestHelper

  test "delivers to the manager when they have notifications on" do
    correction_request = attendance_correction_requests(:bob_pending)

    assert_emails 1 do
      AttendanceCorrectionRequestSubmittedNotifierJob.perform_now(correction_request)
    end
  end

  test "no-ops when the manager opted out of notifications" do
    correction_request = attendance_correction_requests(:request_to_optout_manager)

    assert_emails 0 do
      AttendanceCorrectionRequestSubmittedNotifierJob.perform_now(correction_request)
    end
  end

  test "no-ops when the employee has no manager" do
    correction_request = attendance_correction_requests(:bob_pending)
    correction_request.employee.update_column(:manager_id, nil)

    assert_emails 0 do
      AttendanceCorrectionRequestSubmittedNotifierJob.perform_now(correction_request)
    end
  end
end
