require "test_helper"

module Employees
  class BenefitEnrollmentsControllerTest < ActionDispatch::IntegrationTest
    test "admin can add a benefit plan" do
      sign_in employees(:admin_amy)
      employee = employees(:worker_bob)

      assert_difference "BenefitEnrollment.count", 1 do
        post employee_benefit_enrollments_path(employee), params: {
          benefit_enrollment: { plan_name: "Dental", provider: "Avega", effectivity_date: 1.month.ago.to_date }
        }
      end

      assert_redirected_to employee_path(employee)
    end

    test "adding a benefit plan fails validation with a blank plan name" do
      sign_in employees(:admin_amy)
      employee = employees(:worker_bob)

      assert_no_difference "BenefitEnrollment.count" do
        post employee_benefit_enrollments_path(employee), params: {
          benefit_enrollment: { plan_name: "", provider: "Avega", effectivity_date: 1.month.ago.to_date }
        }
      end

      assert_redirected_to employee_path(employee)
    end

    test "admin can update a benefit plan" do
      sign_in employees(:admin_amy)
      enrollment = benefit_enrollments(:bob_hmo)

      patch employee_benefit_enrollment_path(enrollment.employee, enrollment), params: {
        benefit_enrollment: { plan_name: enrollment.plan_name, provider: "Intellicare", effectivity_date: enrollment.effectivity_date }
      }

      assert_redirected_to employee_path(enrollment.employee)
      assert_equal "Intellicare", enrollment.reload.provider
    end

    test "admin can remove a benefit plan, which also removes its dependents" do
      sign_in employees(:admin_amy)
      enrollment = benefit_enrollments(:bob_hmo)

      assert_difference [ "BenefitEnrollment.count", "BenefitDependent.count" ], -1 do
        delete employee_benefit_enrollment_path(enrollment.employee, enrollment)
      end

      assert_redirected_to employee_path(employees(:worker_bob))
    end

    test "manager is forbidden" do
      sign_in employees(:manager_jane)
      employee = employees(:worker_bob)

      post employee_benefit_enrollments_path(employee), params: {
        benefit_enrollment: { plan_name: "Dental", provider: "Avega", effectivity_date: 1.month.ago.to_date }
      }

      assert_redirected_to root_path
    end

    private

    def sign_in(employee)
      post session_path, params: { work_email: employee.work_email, password: "password" }
    end
  end
end
