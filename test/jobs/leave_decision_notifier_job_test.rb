require "test_helper"

class LeaveDecisionNotifierJobTest < ActiveJob::TestCase
  include ActionMailer::TestHelper
  test "delivers to the employee when they have notifications on" do
    leave_request = leave_requests(:bob_pending)
    leave_request.update!(status: :approved, decided_at: Time.current)

    assert_emails 1 do
      LeaveDecisionNotifierJob.perform_now(leave_request)
    end
  end

  test "no-ops when the employee opted out of notifications" do
    leave_request = leave_requests(:optout_employee_pending)
    leave_request.update!(status: :rejected, decided_at: Time.current)

    assert_emails 0 do
      LeaveDecisionNotifierJob.perform_now(leave_request)
    end
  end
end
