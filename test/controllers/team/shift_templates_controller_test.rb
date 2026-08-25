require "test_helper"

module Team
  class ShiftTemplatesControllerTest < ActionDispatch::IntegrationTest
    test "admin can create a shift template" do
      sign_in employees(:admin_amy)

      post team_shift_templates_path, params: {
        shift_template: { name: "Mid Shift", start_time: "16:00", end_time: "22:00" }
      }

      assert_redirected_to team_attendance_records_path
      created = ShiftTemplate.order(:created_at).last
      assert_equal "Mid Shift", created.name
      assert_equal companies(:acme), created.company
    end

    test "admin can update a shift template" do
      sign_in employees(:admin_amy)
      shift_template = shift_templates(:night_shift)

      patch team_shift_template_path(shift_template), params: { shift_template: { name: "Graveyard" } }

      assert_redirected_to team_attendance_records_path
      assert_equal "Graveyard", shift_template.reload.name
    end

    test "admin can delete an unused shift template" do
      sign_in employees(:admin_amy)
      shift_template = shift_templates(:night_shift)

      delete team_shift_template_path(shift_template)

      assert_redirected_to team_attendance_records_path
      assert_not ShiftTemplate.exists?(shift_template.id)
    end

    test "deleting a shift template with attendance records is blocked with an alert" do
      sign_in employees(:admin_amy)
      shift_template = shift_templates(:day_shift)

      delete team_shift_template_path(shift_template)

      assert_redirected_to team_attendance_records_path
      assert ShiftTemplate.exists?(shift_template.id)
      assert_not_nil flash[:alert]
    end

    test "a manager is forbidden from creating a shift template" do
      sign_in employees(:manager_jane)

      post team_shift_templates_path, params: {
        shift_template: { name: "Mid Shift", start_time: "16:00", end_time: "22:00" }
      }

      assert_redirected_to root_path
    end

    test "an admin cannot update another company's shift template" do
      sign_in employees(:admin_amy)
      other_company_template = shift_templates(:globex_shift)

      patch team_shift_template_path(other_company_template), params: { shift_template: { name: "Hijacked" } }

      assert_redirected_to root_path
      assert_not_equal "Hijacked", other_company_template.reload.name
    end

    private

    def sign_in(employee)
      post session_path, params: { work_email: employee.work_email, password: "password" }
    end
  end
end
