require "test_helper"

module Leave
  class SubmitRequestTest < ActiveJob::TestCase
    test "enqueues a submitted-notification job for the approver" do
      employee = employees(:worker_bob)

      assert_enqueued_with(job: LeaveRequestSubmittedNotifierJob) do
        result = Leave::SubmitRequest.call(
          employee: employee,
          leave_type_id: leave_types(:vacation).id,
          start_date: Date.new(2026, 10, 1),
          end_date: Date.new(2026, 10, 2),
          days_requested: 2,
          reason: "Trip"
        )

        assert result.success?
      end
    end
  end
end
