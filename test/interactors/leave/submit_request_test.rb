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

    test "populates context.leave_request on an overlap failure, for inline field errors" do
      employee = employees(:worker_bob)
      LeaveRequest.create!(
        employee: employee, leave_type: leave_types(:vacation),
        start_date: Date.new(2026, 10, 1), end_date: Date.new(2026, 10, 3), days_requested: 3
      )

      result = Leave::SubmitRequest.call(
        employee: employee, leave_type_id: leave_types(:vacation).id,
        start_date: Date.new(2026, 10, 2), end_date: Date.new(2026, 10, 4), days_requested: 3, reason: nil
      )

      assert_not result.success?
      assert_not_nil result.leave_request
      assert result.leave_request.errors[:start_date].any?
    end

    test "populates context.leave_request on a validation failure, for inline field errors" do
      employee = employees(:worker_bob)

      result = Leave::SubmitRequest.call(
        employee: employee, leave_type_id: leave_types(:vacation).id,
        start_date: Date.new(2026, 10, 5), end_date: Date.new(2026, 10, 1), days_requested: 3, reason: nil
      )

      assert_not result.success?
      assert_not_nil result.leave_request
      assert result.leave_request.errors[:end_date].any?
    end
  end
end
