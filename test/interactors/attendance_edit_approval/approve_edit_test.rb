require "test_helper"

module AttendanceEditApproval
  class ApproveEditTest < ActiveJob::TestCase
    test "approves a pending edit, sets edit_approved_by/at, and notifies the editor" do
      record = attendance_records(:bob_late)
      record.update!(edit_approval_status: :pending, edited_by: employees(:manager_jane))
      approver = employees(:admin_amy)

      assert_enqueued_with(job: AttendanceEditDecisionNotifierJob, args: [ record ]) do
        result = AttendanceEditApproval::ApproveEdit.call(attendance_record: record, approver: approver)

        assert result.success?
      end

      record.reload
      assert record.edit_approval_approved?
      assert_equal approver, record.edit_approved_by
      assert record.edit_approved_at.present?
    end

    test "fails without raising when the edit has already been decided" do
      record = attendance_records(:bob_late)
      record.update!(edit_approval_status: :approved, edited_by: employees(:manager_jane))
      approver = employees(:admin_amy)

      result = AttendanceEditApproval::ApproveEdit.call(attendance_record: record, approver: approver)

      assert result.failure?
    end
  end
end
