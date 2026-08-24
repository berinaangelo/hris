require "test_helper"

module Team
  class ApprovalsControllerTest < ActionDispatch::IntegrationTest
    test "manager can reject a pending request with a reason" do
      sign_in employees(:manager_jane)
      leave_request = leave_requests(:bob_pending)

      patch reject_team_approval_path(leave_request), params: { decision_note: "Not enough coverage" }

      assert_redirected_to team_approvals_path
      leave_request.reload
      assert leave_request.rejected?
      assert_equal "Not enough coverage", leave_request.decision_note
    end

    test "manager can reject a pending request without a reason" do
      sign_in employees(:manager_jane)
      leave_request = leave_requests(:bob_pending)

      patch reject_team_approval_path(leave_request)

      assert_redirected_to team_approvals_path
      assert leave_request.reload.rejected?
      assert_nil leave_request.decision_note
    end

    test "the reject reason shows up in the recently-decided table" do
      sign_in employees(:manager_jane)
      leave_request = leave_requests(:bob_pending)
      leave_request.update!(status: :rejected, decided_at: Time.current, decision_note: "Not enough coverage")

      get team_approvals_path

      assert_response :success
      assert_match "Not enough coverage", response.body
    end

    private

    def sign_in(employee)
      post session_path, params: { work_email: employee.work_email, password: "password" }
    end
  end
end
