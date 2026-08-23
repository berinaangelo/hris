require "test_helper"

class LeaveRequestSubmittedNotifierJobTest < ActiveJob::TestCase
  include ActionMailer::TestHelper
  test "delivers to the approver when they have notifications on" do
    assert_emails 1 do
      LeaveRequestSubmittedNotifierJob.perform_now(leave_requests(:bob_pending))
    end
  end

  test "no-ops when the approver opted out of notifications" do
    assert_emails 0 do
      LeaveRequestSubmittedNotifierJob.perform_now(leave_requests(:request_to_optout_manager))
    end
  end

  test "no-ops when the request has no approver" do
    assert_emails 0 do
      LeaveRequestSubmittedNotifierJob.perform_now(leave_requests(:no_manager_pending))
    end
  end
end
