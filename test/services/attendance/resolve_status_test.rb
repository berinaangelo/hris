require "test_helper"

module Attendance
  class ResolveStatusTest < ActiveSupport::TestCase
    test "resolves on_time when within the shift window" do
      employee = employees(:worker_carol)
      shift = shift_templates(:day_shift)
      record = employee.attendance_records.build(
        date: employee.company.today,
        shift_template: shift,
        clock_in_at: employee.company.today.in_time_zone(employee.company.timezone).change(hour: 9),
        clock_out_at: employee.company.today.in_time_zone(employee.company.timezone).change(hour: 18)
      )

      assert_equal :on_time, Attendance::ResolveStatus.call(record)
    end

    test "resolves late when clocked in after the shift start time, taking priority over undertime" do
      employee = employees(:worker_carol)
      shift = shift_templates(:day_shift)
      record = employee.attendance_records.build(
        date: employee.company.today,
        shift_template: shift,
        clock_in_at: employee.company.today.in_time_zone(employee.company.timezone).change(hour: 10),
        clock_out_at: employee.company.today.in_time_zone(employee.company.timezone).change(hour: 17)
      )

      assert_equal :late, Attendance::ResolveStatus.call(record)
    end

    test "resolves undertime when clocked out before the shift end time" do
      employee = employees(:worker_carol)
      shift = shift_templates(:day_shift)
      record = employee.attendance_records.build(
        date: employee.company.today,
        shift_template: shift,
        clock_in_at: employee.company.today.in_time_zone(employee.company.timezone).change(hour: 9),
        clock_out_at: employee.company.today.in_time_zone(employee.company.timezone).change(hour: 16)
      )

      assert_equal :undertime, Attendance::ResolveStatus.call(record)
    end
  end
end
