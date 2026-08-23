require "test_helper"

module Leave
  class RejectRequestTest < ActiveJob::TestCase
    test "enqueues a decision-notification job" do
      leave_request = leave_requests(:bob_pending)

      assert_enqueued_with(job: LeaveDecisionNotifierJob, args: [ leave_request ]) do
        result = Leave::RejectRequest.call(leave_request: leave_request, decision_note: "Not enough coverage")

        assert result.success?
      end

      assert leave_request.reload.rejected?
    end
  end
end
