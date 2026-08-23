require "test_helper"

module Team
  class AttendanceSettingsControllerTest < ActionDispatch::IntegrationTest
    test "admin can toggle both attendance settings" do
      sign_in employees(:admin_amy)
      company = employees(:admin_amy).company

      patch team_attendance_settings_path, params: {
        company: { attendance_manual_edit_enabled: false, attendance_approvers_enabled: true }
      }

      assert_redirected_to team_attendance_records_path
      company.reload
      assert_not company.attendance_manual_edit_enabled
      assert company.attendance_approvers_enabled
    end

    test "manager is forbidden" do
      sign_in employees(:manager_jane)
      company = employees(:manager_jane).company

      patch team_attendance_settings_path, params: {
        company: { attendance_manual_edit_enabled: false }
      }

      assert_redirected_to root_path
      assert company.reload.attendance_manual_edit_enabled
    end

    test "plain employee is forbidden" do
      sign_in employees(:worker_bob)
      company = employees(:worker_bob).company

      patch team_attendance_settings_path, params: {
        company: { attendance_manual_edit_enabled: false }
      }

      assert_redirected_to root_path
      assert company.reload.attendance_manual_edit_enabled
    end

    private

    def sign_in(employee)
      post session_path, params: { work_email: employee.work_email, password: "password" }
    end
  end
end
