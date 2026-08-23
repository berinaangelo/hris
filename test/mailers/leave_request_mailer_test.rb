require "test_helper"

class LeaveRequestMailerTest < ActionMailer::TestCase
  test "submitted_email goes to the approver's work email" do
    leave_request = leave_requests(:bob_pending)
    email = LeaveRequestMailer.submitted_email(leave_request)

    assert_equal [ employees(:manager_jane).work_email ], email.to
    assert_match "Bob Worker", email.subject
    assert_match "Vacation", email.body.to_s
  end

  test "decision_email goes to the employee's work email" do
    leave_request = leave_requests(:bob_pending)
    leave_request.update!(status: :approved, decided_at: Time.current)

    email = LeaveRequestMailer.decision_email(leave_request)

    assert_equal [ employees(:worker_bob).work_email ], email.to
    assert_match "approved", email.subject
  end
end
