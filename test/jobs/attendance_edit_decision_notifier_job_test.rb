require "test_helper"

class AttendanceEditDecisionNotifierJobTest < ActiveJob::TestCase
  include ActionMailer::TestHelper

  test "delivers to the editor when they have notifications on" do
    record = attendance_records(:bob_late)
    record.update!(edit_approval_status: :approved, edited_by: employees(:manager_jane))

    assert_emails 1 do
      AttendanceEditDecisionNotifierJob.perform_now(record)
    end
  end

  test "no-ops when the editor opted out of notifications" do
    record = attendance_records(:bob_late)
    record.update!(edit_approval_status: :rejected, edited_by: employees(:manager_optout))

    assert_emails 0 do
      AttendanceEditDecisionNotifierJob.perform_now(record)
    end
  end
end
