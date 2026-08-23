require "test_helper"

module AttendanceCorrection
  class SubmitRequestTest < ActiveJob::TestCase
    test "enqueues a submitted-notification job and links the existing attendance record" do
      employee = employees(:worker_carol)

      assert_enqueued_with(job: AttendanceCorrectionRequestSubmittedNotifierJob) do
        result = AttendanceCorrection::SubmitRequest.call(
          employee: employee,
          date: attendance_records(:carol_ontime).date,
          requested_clock_in_at: Time.zone.parse("2026-08-15 09:30:00"),
          requested_clock_out_at: nil,
          reason: "Traffic"
        )

        assert result.success?
        assert_equal attendance_records(:carol_ontime), result.correction_request.attendance_record
      end
    end

    test "fails when the employee already has a pending request for that date" do
      existing = attendance_correction_requests(:bob_pending)

      result = AttendanceCorrection::SubmitRequest.call(
        employee: existing.employee,
        date: existing.date,
        requested_clock_in_at: Time.zone.parse("2026-08-10 09:15:00"),
        requested_clock_out_at: nil,
        reason: "Another reason"
      )

      assert result.failure?
    end
  end
end
