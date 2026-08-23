require "test_helper"

module Employees
  class BenefitDependentsControllerTest < ActionDispatch::IntegrationTest
    test "admin can add a dependent" do
      sign_in employees(:admin_amy)
      enrollment = benefit_enrollments(:bob_group_life)

      assert_difference "BenefitDependent.count", 1 do
        post employee_benefit_enrollment_benefit_dependents_path(enrollment.employee, enrollment), params: {
          benefit_dependent: { name: "Junior Worker", relationship: "child" }
        }
      end

      assert_redirected_to employee_path(enrollment.employee)
    end

    test "adding a dependent fails validation with a blank name" do
      sign_in employees(:admin_amy)
      enrollment = benefit_enrollments(:bob_group_life)

      assert_no_difference "BenefitDependent.count" do
        post employee_benefit_enrollment_benefit_dependents_path(enrollment.employee, enrollment), params: {
          benefit_dependent: { name: "", relationship: "child" }
        }
      end

      assert_redirected_to employee_path(enrollment.employee)
    end

    test "admin can remove a dependent" do
      sign_in employees(:admin_amy)
      dependent = benefit_dependents(:bob_hmo_spouse)
      enrollment = dependent.benefit_enrollment

      assert_difference "BenefitDependent.count", -1 do
        delete employee_benefit_enrollment_benefit_dependent_path(enrollment.employee, enrollment, dependent)
      end

      assert_redirected_to employee_path(enrollment.employee)
    end

    test "manager is forbidden" do
      sign_in employees(:manager_jane)
      enrollment = benefit_enrollments(:bob_group_life)

      post employee_benefit_enrollment_benefit_dependents_path(enrollment.employee, enrollment), params: {
        benefit_dependent: { name: "Junior Worker", relationship: "child" }
      }

      assert_redirected_to root_path
    end

    private

    def sign_in(employee)
      post session_path, params: { work_email: employee.work_email, password: "password" }
    end
  end
end
