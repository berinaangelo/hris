require "test_helper"

module Team
  class AttendanceEditApprovalsControllerTest < ActionDispatch::IntegrationTest
    test "admin can approve a pending edit" do
      sign_in employees(:admin_amy)
      record = attendance_records(:bob_late)
      record.update!(edit_approval_status: :pending, edited_by: employees(:manager_jane))

      patch approve_team_attendance_edit_approval_path(record)

      assert_redirected_to team_attendance_edit_approvals_path
      assert record.reload.edit_approval_approved?
    end

    test "admin can reject a pending edit" do
      sign_in employees(:admin_amy)
      record = attendance_records(:bob_late)
      record.update!(edit_approval_status: :pending, edited_by: employees(:manager_jane))

      patch reject_team_attendance_edit_approval_path(record)

      assert_redirected_to team_attendance_edit_approvals_path
      assert record.reload.edit_approval_rejected?
    end

    test "a manager is forbidden from approving" do
      sign_in employees(:manager_jane)
      record = attendance_records(:bob_late)
      record.update!(edit_approval_status: :pending, edited_by: employees(:manager_jane))

      patch approve_team_attendance_edit_approval_path(record)

      assert_redirected_to root_path
      assert record.reload.edit_approval_pending?
    end

    test "a manager is forbidden from viewing the index" do
      sign_in employees(:manager_jane)

      get team_attendance_edit_approvals_path

      assert_redirected_to root_path
    end

    private

    def sign_in(employee)
      post session_path, params: { work_email: employee.work_email, password: "password" }
    end
  end
end
