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

    test "manager is forbidden from updating a benefit plan" do
      sign_in employees(:manager_jane)
      enrollment = benefit_enrollments(:bob_hmo)

      patch employee_benefit_enrollment_path(enrollment.employee, enrollment), params: {
        benefit_enrollment: { plan_name: "Should Not Save", provider: enrollment.provider, effectivity_date: enrollment.effectivity_date }
      }

      assert_redirected_to root_path
      assert_equal "Gold HMO", enrollment.reload.plan_name
    end

    test "manager is forbidden from destroying a benefit plan" do
      sign_in employees(:manager_jane)
      enrollment = benefit_enrollments(:bob_hmo)

      assert_no_difference "BenefitEnrollment.count" do
        delete employee_benefit_enrollment_path(enrollment.employee, enrollment)
      end

      assert_redirected_to root_path
    end

    test "admin cannot update another company's benefit plan" do
      sign_in employees(:admin_gary)
      enrollment = benefit_enrollments(:bob_hmo)

      patch employee_benefit_enrollment_path(enrollment.employee, enrollment), params: {
        benefit_enrollment: { plan_name: "Should Not Save", provider: enrollment.provider, effectivity_date: enrollment.effectivity_date }
      }

      assert_response :not_found
      assert_equal "Gold HMO", enrollment.reload.plan_name
    end

    test "admin cannot destroy another company's benefit plan" do
      sign_in employees(:admin_gary)
      enrollment = benefit_enrollments(:bob_hmo)

      assert_no_difference "BenefitEnrollment.count" do
        delete employee_benefit_enrollment_path(enrollment.employee, enrollment)
      end

      assert_response :not_found
    end

    test "editing a plan's fields without touching dependents succeeds" do
      # Reproduces exactly what the real form posts: the existing
      # persisted dependent untouched, plus the trailing auto-built
      # "add a dependent" row left blank (relationship included as ""
      # since the select now has include_blank: true) — this is the
      # regression test for the bug where that trailing row defeated
      # reject_if: :all_blank and silently failed the whole update.
      sign_in employees(:admin_amy)
      enrollment = benefit_enrollments(:bob_hmo)
      spouse = benefit_dependents(:bob_hmo_spouse)

      patch employee_benefit_enrollment_path(enrollment.employee, enrollment), params: {
        benefit_enrollment: {
          plan_name: "Platinum HMO", provider: enrollment.provider, effectivity_date: enrollment.effectivity_date,
          benefit_dependents_attributes: {
            "0" => { id: spouse.id, name: spouse.name, relationship: spouse.relationship },
            "1" => { name: "", relationship: "" }
          }
        }
      }

      assert_redirected_to employee_path(enrollment.employee)
      assert_equal "Platinum HMO", enrollment.reload.plan_name
      assert_equal 1, enrollment.benefit_dependents.count
    end

    test "validation failure on update preserves typed values and re-renders" do
      sign_in employees(:admin_amy)
      enrollment = benefit_enrollments(:bob_hmo)

      patch employee_benefit_enrollment_path(enrollment.employee, enrollment), params: {
        benefit_enrollment: { plan_name: "Should Not Be Lost", provider: "", effectivity_date: enrollment.effectivity_date }
      }

      assert_response :unprocessable_entity
      assert_match "Should Not Be Lost", response.body
      assert_equal "Gold HMO", enrollment.reload.plan_name
    end

    test "validation failure on create preserves typed values and re-renders" do
      sign_in employees(:admin_amy)
      employee = employees(:worker_carol)

      assert_no_difference "BenefitEnrollment.count" do
        post employee_benefit_enrollments_path(employee), params: {
          benefit_enrollment: { plan_name: "", provider: "Intellicare", effectivity_date: Date.current }
        }
      end

      assert_response :unprocessable_entity
      assert_match "Intellicare", response.body
    end

    test "a tampered relationship value returns a validation error, not a 500" do
      sign_in employees(:admin_amy)
      enrollment = benefit_enrollments(:bob_hmo)

      assert_no_difference "BenefitDependent.count" do
        patch employee_benefit_enrollment_path(enrollment.employee, enrollment), params: {
          benefit_enrollment: {
            plan_name: enrollment.plan_name, provider: enrollment.provider, effectivity_date: enrollment.effectivity_date,
            benefit_dependents_attributes: { "0" => { name: "New Dependent", relationship: "sibling" } }
          }
        }
      end

      assert_response :unprocessable_entity
    end

    private

    def sign_in(employee)
      post session_path, params: { work_email: employee.work_email, password: "password" }
    end
  end
end
