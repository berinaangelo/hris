require "test_helper"

class AttendanceRecordTest < ActiveSupport::TestCase
  test "invalid when clock out is before clock in" do
    record = AttendanceRecord.new(
      employee: employees(:worker_carol),
      shift_template: shift_templates(:day_shift),
      date: Date.new(2026, 8, 20),
      clock_in_at: Time.zone.parse("2026-08-20 09:00:00"),
      clock_out_at: Time.zone.parse("2026-08-20 08:00:00")
    )

    assert_not record.valid?
    assert_includes record.errors[:clock_out_at], "can't be before the clock in time"
  end

  test "valid when clock out is after clock in" do
    record = AttendanceRecord.new(
      employee: employees(:worker_carol),
      shift_template: shift_templates(:day_shift),
      date: Date.new(2026, 8, 20),
      clock_in_at: Time.zone.parse("2026-08-20 09:00:00"),
      clock_out_at: Time.zone.parse("2026-08-20 18:00:00")
    )

    assert record.valid?
  end

  test "edit_approval_status accepts rejected alongside not_required/pending/approved" do
    record = attendance_records(:bob_late)

    record.edit_approval_status = :rejected

    assert record.edit_approval_rejected?
  end
end
