require "test_helper"

module Leave
  class ApproveRequestTest < ActiveJob::TestCase
    test "enqueues a decision-notification job" do
      leave_request = leave_requests(:bob_pending)

      assert_enqueued_with(job: LeaveDecisionNotifierJob, args: [ leave_request ]) do
        result = Leave::ApproveRequest.call(leave_request: leave_request)

        assert result.success?
      end

      assert leave_request.reload.approved?
    end
  end
end
