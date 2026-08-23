require "test_helper"

class AttendanceEditApprovalMailerTest < ActionMailer::TestCase
  test "decision_email goes to the editor's work email when approved" do
    record = attendance_records(:bob_late)
    record.update!(edit_approval_status: :approved, edited_by: employees(:manager_jane))

    email = AttendanceEditApprovalMailer.decision_email(record)

    assert_equal [ employees(:manager_jane).work_email ], email.to
    assert_match "approved", email.subject
  end

  test "decision_email goes to the editor's work email when rejected" do
    record = attendance_records(:bob_late)
    record.update!(edit_approval_status: :rejected, edited_by: employees(:manager_jane))

    email = AttendanceEditApprovalMailer.decision_email(record)

    assert_equal [ employees(:manager_jane).work_email ], email.to
    assert_match "rejected", email.subject
  end
end
