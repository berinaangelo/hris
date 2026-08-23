require "test_helper"

module Attendance
  class RecordClockInTest < ActiveSupport::TestCase
    test "creates today's attendance record, snapshotting the employee's shift template" do
      employee = employees(:worker_carol)

      result = Attendance::RecordClockIn.call(employee: employee)

      assert result.success?
      assert_equal employee.company.today, result.attendance_record.date
      assert_equal employee.shift_template, result.attendance_record.shift_template
      assert_not_nil result.attendance_record.clock_in_at
    end

    test "fails when the employee has no shift template assigned" do
      employee = employees(:worker_bob)
      assert_nil employee.shift_template

      result = Attendance::RecordClockIn.call(employee: employee)

      assert result.failure?
      assert_not employee.attendance_records.exists?(date: employee.company.today)
    end

    test "fails when already clocked in today" do
      employee = employees(:worker_carol)
      Attendance::RecordClockIn.call(employee: employee)

      result = Attendance::RecordClockIn.call(employee: employee)

      assert result.failure?
      assert_equal 1, employee.attendance_records.where(date: employee.company.today).count
    end
  end
end
