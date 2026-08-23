require "test_helper"

module AttendanceEditApproval
  class RejectEditTest < ActiveJob::TestCase
    test "rejects a pending edit without touching clock_in_at/clock_out_at" do
      record = attendance_records(:bob_late)
      record.update!(edit_approval_status: :pending, edited_by: employees(:manager_jane))
      original_clock_in = record.clock_in_at
      original_clock_out = record.clock_out_at
      approver = employees(:admin_amy)

      assert_enqueued_with(job: AttendanceEditDecisionNotifierJob, args: [ record ]) do
        result = AttendanceEditApproval::RejectEdit.call(attendance_record: record, approver: approver)

        assert result.success?
      end

      record.reload
      assert record.edit_approval_rejected?
      assert_equal approver, record.edit_approved_by
      assert record.edit_approved_at.present?
      assert_equal original_clock_in, record.clock_in_at
      assert_equal original_clock_out, record.clock_out_at
    end

    test "fails without raising when the edit has already been decided" do
      record = attendance_records(:bob_late)
      record.update!(edit_approval_status: :rejected, edited_by: employees(:manager_jane))
      approver = employees(:admin_amy)

      result = AttendanceEditApproval::RejectEdit.call(attendance_record: record, approver: approver)

      assert result.failure?
    end
  end
end
