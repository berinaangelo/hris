require "test_helper"

class AttendanceCorrectionRequestTest < ActiveSupport::TestCase
  test "invalid without a reason" do
    request = AttendanceCorrectionRequest.new(
      employee: employees(:worker_bob),
      date: Date.new(2026, 8, 20),
      requested_clock_in_at: Time.zone.parse("2026-08-20 09:00:00")
    )

    assert_not request.valid?
    assert_includes request.errors[:reason], "can't be blank"
  end

  test "invalid without a requested clock in or clock out time" do
    request = AttendanceCorrectionRequest.new(
      employee: employees(:worker_bob),
      date: Date.new(2026, 8, 20),
      reason: "Forgot to clock in"
    )

    assert_not request.valid?
  end

  test "valid with only a requested clock out time" do
    request = AttendanceCorrectionRequest.new(
      employee: employees(:worker_bob),
      date: Date.new(2026, 8, 20),
      requested_clock_out_at: Time.zone.parse("2026-08-20 18:00:00"),
      reason: "Forgot to clock out"
    )

    assert request.valid?
  end

  test ".pending_for scopes to pending requests for that employee and date" do
    existing = attendance_correction_requests(:bob_pending)

    assert_includes AttendanceCorrectionRequest.pending_for(existing.employee_id, existing.date), existing
    assert_not AttendanceCorrectionRequest.pending_for(existing.employee_id, existing.date + 1.day).exists?
  end
end
