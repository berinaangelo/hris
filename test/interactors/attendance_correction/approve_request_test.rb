require "test_helper"

module AttendanceCorrection
  class ApproveRequestTest < ActiveJob::TestCase
    test "applies the correction to the existing attendance record and notifies the employee" do
      correction_request = attendance_correction_requests(:bob_pending)
      reviewer = employees(:manager_jane)

      assert_enqueued_with(job: AttendanceCorrectionDecisionNotifierJob, args: [ correction_request ]) do
        result = AttendanceCorrection::ApproveRequest.call(correction_request: correction_request, reviewer: reviewer)

        assert result.success?
      end

      correction_request.reload
      assert correction_request.approved?
      assert_equal reviewer, correction_request.reviewed_by

      attendance_record = correction_request.attendance_record.reload
      assert_equal Time.zone.parse("2026-08-10 09:00:00"), attendance_record.clock_in_at
      assert attendance_record.manually_edited?
      assert_equal reviewer, attendance_record.edited_by
      assert attendance_record.edit_approval_approved?
    end

    test "creates a new attendance record when the punch was missed entirely" do
      correction_request = attendance_correction_requests(:optout_employee_pending)
      reviewer = employees(:manager_jane)

      assert_nil correction_request.attendance_record

      result = AttendanceCorrection::ApproveRequest.call(correction_request: correction_request, reviewer: reviewer)

      assert result.success?
      correction_request.reload
      assert_not_nil correction_request.attendance_record
      assert_equal correction_request.date, correction_request.attendance_record.date
    end

    test "fails without raising when the employee has no shift template and no attendance record yet" do
      correction_request = attendance_correction_requests(:optout_employee_pending)
      correction_request.employee.update_column(:shift_template_id, nil)
      reviewer = employees(:manager_jane)

      result = AttendanceCorrection::ApproveRequest.call(correction_request: correction_request, reviewer: reviewer)

      assert result.failure?
      assert correction_request.reload.pending?
    end
  end
end
