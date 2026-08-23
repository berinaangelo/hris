require "test_helper"

module Employees
  class BenefitEnrollmentsControllerTest < ActionDispatch::IntegrationTest
    test "admin can add a benefit plan for an employee" do
      sign_in employees(:admin_amy)
      employee = employees(:worker_carol)

      assert_difference "BenefitEnrollment.count", 1 do
        post employee_benefit_enrollments_path(employee), params: {
          benefit_enrollment: { plan_name: "Silver HMO", provider: "Intellicare", effectivity_date: Date.current }
        }
      end

      assert_redirected_to employee_path(employee)
    end

    test "admin can update a plan and add a dependent in the same submit" do
      sign_in employees(:admin_amy)
      enrollment = benefit_enrollments(:bob_hmo)

      assert_difference "BenefitDependent.count", 1 do
        patch employee_benefit_enrollment_path(enrollment.employee, enrollment), params: {
          benefit_enrollment: {
            plan_name: enrollment.plan_name, provider: enrollment.provider, effectivity_date: enrollment.effectivity_date,
            benefit_dependents_attributes: { "0" => { name: "Bobby Jr.", relationship: "child" } }
          }
        }
      end

      assert_redirected_to employee_path(enrollment.employee)
    end

    test "a blank dependent row is not saved as an empty record" do
      sign_in employees(:admin_amy)
      enrollment = benefit_enrollments(:bob_hmo)

      assert_no_difference "BenefitDependent.count" do
        patch employee_benefit_enrollment_path(enrollment.employee, enrollment), params: {
          benefit_enrollment: {
            plan_name: enrollment.plan_name, provider: enrollment.provider, effectivity_date: enrollment.effectivity_date,
            benefit_dependents_attributes: { "0" => { name: "", relationship: "child" } }
          }
        }
      end
    end

    test "admin can remove a dependent via nested attributes" do
      sign_in employees(:admin_amy)
      enrollment = benefit_enrollments(:bob_hmo)
      dependent = benefit_dependents(:bob_hmo_spouse)

      assert_difference "BenefitDependent.count", -1 do
        patch employee_benefit_enrollment_path(enrollment.employee, enrollment), params: {
          benefit_enrollment: {
            plan_name: enrollment.plan_name, provider: enrollment.provider, effectivity_date: enrollment.effectivity_date,
            benefit_dependents_attributes: { "0" => { id: dependent.id, _destroy: "1" } }
          }
        }
      end
    end

    test "admin can remove a plan" do
      sign_in employees(:admin_amy)
      enrollment = benefit_enrollments(:bob_hmo)

      assert_difference "BenefitEnrollment.count", -1 do
        delete employee_benefit_enrollment_path(enrollment.employee, enrollment)
      end

      assert_redirected_to employee_path(enrollment.employee)
    end

    test "manager is forbidden" do
      sign_in employees(:manager_jane)
      employee = employees(:worker_carol)

      post employee_benefit_enrollments_path(employee), params: {
        benefit_enrollment: { plan_name: "Silver HMO", provider: "Intellicare", effectivity_date: Date.current }
      }

      assert_redirected_to root_path
    end

    private

    def sign_in(employee)
      post session_path, params: { work_email: employee.work_email, password: "password" }
    end
  end
end
