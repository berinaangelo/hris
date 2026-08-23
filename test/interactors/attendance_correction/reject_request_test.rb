require "test_helper"

module AttendanceCorrection
  class RejectRequestTest < ActiveJob::TestCase
    test "enqueues a decision-notification job" do
      correction_request = attendance_correction_requests(:bob_pending)
      reviewer = employees(:manager_jane)

      assert_enqueued_with(job: AttendanceCorrectionDecisionNotifierJob, args: [ correction_request ]) do
        result = AttendanceCorrection::RejectRequest.call(correction_request: correction_request, reviewer: reviewer)

        assert result.success?
      end

      correction_request.reload
      assert correction_request.rejected?
      assert_equal reviewer, correction_request.reviewed_by
    end
  end
end
