require "test_helper"

module AttendanceRecords
  class ForDateRangeTest < ActiveSupport::TestCase
    test "returns records in range for the viewer's scope, unfiltered by default" do
      records = AttendanceRecords::ForDateRange.call(
        viewer: employees(:manager_jane), start_date: Date.new(2026, 8, 1), end_date: Date.new(2026, 8, 31)
      )

      assert_includes records, attendance_records(:bob_late)
    end

    test "status narrows the results" do
      records = AttendanceRecords::ForDateRange.call(
        viewer: employees(:admin_amy), start_date: Date.new(2026, 8, 1), end_date: Date.new(2026, 8, 31), status: "late"
      )

      assert_includes records, attendance_records(:bob_late)
      assert_not_includes records, attendance_records(:carol_ontime)
    end

    test "an invalid status is ignored rather than raising" do
      records = AttendanceRecords::ForDateRange.call(
        viewer: employees(:admin_amy), start_date: Date.new(2026, 8, 1), end_date: Date.new(2026, 8, 31), status: "bogus"
      )

      assert_includes records, attendance_records(:bob_late)
      assert_includes records, attendance_records(:carol_ontime)
    end

    test "search matches first or last name, case-insensitively" do
      records = AttendanceRecords::ForDateRange.call(
        viewer: employees(:admin_amy), start_date: Date.new(2026, 8, 1), end_date: Date.new(2026, 8, 31),
        search: employees(:worker_bob).last_name.downcase
      )

      assert_includes records, attendance_records(:bob_late)
      assert_not_includes records, attendance_records(:carol_ontime)
    end

    test "a blank search returns everything in range" do
      records = AttendanceRecords::ForDateRange.call(
        viewer: employees(:admin_amy), start_date: Date.new(2026, 8, 1), end_date: Date.new(2026, 8, 31), search: ""
      )

      assert_includes records, attendance_records(:bob_late)
      assert_includes records, attendance_records(:carol_ontime)
    end
  end
end
