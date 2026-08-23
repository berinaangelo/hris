require "test_helper"

module Attendance
  class RecordClockOutTest < ActiveSupport::TestCase
    include ActiveSupport::Testing::TimeHelpers

    test "fails when the employee hasn't clocked in yet" do
      employee = employees(:worker_carol)

      result = Attendance::RecordClockOut.call(employee: employee)

      assert result.failure?
    end

    test "fails when already clocked out today" do
      employee = employees(:worker_carol)
      Attendance::RecordClockIn.call(employee: employee)
      Attendance::RecordClockOut.call(employee: employee)

      result = Attendance::RecordClockOut.call(employee: employee)

      assert result.failure?
    end

    test "resolves on_time when within the shift window" do
      employee = employees(:worker_carol)
      shift = shift_templates(:day_shift)
      record = employee.attendance_records.create!(
        date: employee.company.today,
        shift_template: shift,
        clock_in_at: employee.company.today.in_time_zone(employee.company.timezone).change(hour: 9)
      )

      travel_to employee.company.today.in_time_zone(employee.company.timezone).change(hour: 18, min: 30) do
        result = Attendance::RecordClockOut.call(employee: employee)
        assert result.success?
      end

      assert record.reload.status_on_time?
    end

    test "resolves late when clocked in after the shift start time, taking priority over undertime" do
      employee = employees(:worker_carol)
      shift = shift_templates(:day_shift)
      record = employee.attendance_records.create!(
        date: employee.company.today,
        shift_template: shift,
        clock_in_at: employee.company.today.in_time_zone(employee.company.timezone).change(hour: 10)
      )

      # Also clocks out early — late should still win per the confirmed priority.
      travel_to employee.company.today.in_time_zone(employee.company.timezone).change(hour: 17) do
        result = Attendance::RecordClockOut.call(employee: employee)
        assert result.success?
      end

      assert record.reload.status_late?
    end

    test "resolves undertime when clocked out before the shift end time" do
      employee = employees(:worker_carol)
      shift = shift_templates(:day_shift)
      record = employee.attendance_records.create!(
        date: employee.company.today,
        shift_template: shift,
        clock_in_at: employee.company.today.in_time_zone(employee.company.timezone).change(hour: 9)
      )

      travel_to employee.company.today.in_time_zone(employee.company.timezone).change(hour: 16) do
        result = Attendance::RecordClockOut.call(employee: employee)
        assert result.success?
      end

      assert record.reload.status_undertime?
    end
  end
end
