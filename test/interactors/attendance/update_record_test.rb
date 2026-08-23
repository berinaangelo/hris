require "test_helper"

module Attendance
  class UpdateRecordTest < ActiveSupport::TestCase
    test "updates clock times and marks the record as manually edited" do
      record = attendance_records(:bob_late)
      editor = employees(:manager_jane)
      new_clock_in = record.date.in_time_zone(record.employee.company.timezone).change(hour: 9, min: 0)

      result = Attendance::UpdateRecord.call(attendance_record: record, clock_in_at: new_clock_in, clock_out_at: nil, editor: editor)

      assert result.success?
      record.reload
      assert_equal new_clock_in, record.clock_in_at
      assert record.manually_edited?
      assert_equal editor, record.edited_by
      assert record.edited_at.present?
    end

    test "recomputes status from the new clock times" do
      record = attendance_records(:bob_late)
      editor = employees(:manager_jane)
      timezone = record.employee.company.timezone
      on_time_clock_in = record.date.in_time_zone(timezone).change(hour: 9, min: 0)
      on_time_clock_out = record.date.in_time_zone(timezone).change(hour: 18, min: 0)

      Attendance::UpdateRecord.call(attendance_record: record, clock_in_at: on_time_clock_in, clock_out_at: on_time_clock_out, editor: editor)

      assert record.reload.status_on_time?
    end

    test "leaves an unset clock time untouched" do
      record = attendance_records(:bob_late)
      editor = employees(:manager_jane)
      original_clock_out = record.clock_out_at

      Attendance::UpdateRecord.call(attendance_record: record, clock_in_at: nil, clock_out_at: nil, editor: editor)

      assert_equal original_clock_out, record.reload.clock_out_at
    end

    test "editing only clock_in_at on an in-progress shift (no clock_out yet) doesn't raise" do
      record = attendance_records(:bob_in_progress)
      editor = employees(:manager_jane)
      new_clock_in = record.date.in_time_zone(record.employee.company.timezone).change(hour: 9, min: 15)

      result = Attendance::UpdateRecord.call(attendance_record: record, clock_in_at: new_clock_in, clock_out_at: nil, editor: editor)

      assert result.success?
      record.reload
      assert_equal new_clock_in, record.clock_in_at
      assert_nil record.clock_out_at
      assert_nil record.status
    end

    test "fails when the resulting record is invalid" do
      record = attendance_records(:bob_late)
      editor = employees(:manager_jane)
      clock_out_before_clock_in = record.clock_in_at - 1.hour

      result = Attendance::UpdateRecord.call(attendance_record: record, clock_in_at: nil, clock_out_at: clock_out_before_clock_in, editor: editor)

      assert result.failure?
    end

    test "a manager's edit goes pending when the company has approvers enabled" do
      record = attendance_records(:bob_late)
      editor = employees(:manager_jane)
      editor.company.update!(attendance_approvers_enabled: true)

      Attendance::UpdateRecord.call(attendance_record: record, clock_in_at: nil, clock_out_at: record.clock_out_at + 1.hour, editor: editor)

      assert record.reload.edit_approval_pending?
    end

    test "a manager's edit stays not_required when the company has approvers disabled" do
      record = attendance_records(:bob_late)
      editor = employees(:manager_jane)

      Attendance::UpdateRecord.call(attendance_record: record, clock_in_at: nil, clock_out_at: record.clock_out_at + 1.hour, editor: editor)

      assert record.reload.edit_approval_not_required?
    end

    test "an admin's edit is never gated, even when approvers are enabled" do
      record = attendance_records(:carol_ontime)
      editor = employees(:admin_amy)
      editor.company.update!(attendance_approvers_enabled: true)

      Attendance::UpdateRecord.call(attendance_record: record, clock_in_at: nil, clock_out_at: record.clock_out_at + 1.hour, editor: editor)

      assert record.reload.edit_approval_not_required?
    end

    test "re-editing an already-decided record resets it back to pending when still gated" do
      record = attendance_records(:bob_late)
      editor = employees(:manager_jane)
      editor.company.update!(attendance_approvers_enabled: true)
      record.update!(edit_approval_status: :approved, edit_approved_by: employees(:admin_amy), edit_approved_at: Time.current)

      Attendance::UpdateRecord.call(attendance_record: record, clock_in_at: nil, clock_out_at: record.clock_out_at + 1.hour, editor: editor)

      record.reload
      assert record.edit_approval_pending?
      assert_nil record.edit_approved_by
      assert_nil record.edit_approved_at
    end
  end
end
