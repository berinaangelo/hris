require "test_helper"

class AttendanceCorrectionRequestMailerTest < ActionMailer::TestCase
  test "submitted_email goes to the manager's work email" do
    correction_request = attendance_correction_requests(:bob_pending)
    email = AttendanceCorrectionRequestMailer.submitted_email(correction_request)

    assert_equal [ employees(:manager_jane).work_email ], email.to
    assert_match "Bob Worker", email.subject
  end

  test "decision_email goes to the employee's work email" do
    correction_request = attendance_correction_requests(:bob_pending)
    correction_request.update!(status: :approved, reviewed_at: Time.current)

    email = AttendanceCorrectionRequestMailer.decision_email(correction_request)

    assert_equal [ employees(:worker_bob).work_email ], email.to
    assert_match "approved", email.subject
  end
end
