require "test_helper"

class JobCandidatesControllerTest < ActionDispatch::IntegrationTest
  test "admin can move a candidate to a new stage" do
    sign_in employees(:admin_amy)
    candidate = job_candidates(:juan_new)

    patch job_candidate_path(candidate), params: { job_candidate: { stage: "interviewing" } }

    assert_redirected_to job_opening_path(candidate.job_opening)
    assert_equal "interviewing", candidate.reload.stage
  end

  test "admin can hire a candidate at offer stage, creating an employee record" do
    sign_in employees(:admin_amy)
    candidate = job_candidates(:maria_offer)

    assert_difference "Employee.count", 1 do
      post hire_job_candidate_path(candidate), params: {
        employee: {
          job_title: "Engineer", department: "Engineering", start_date: Date.current,
          employment_type: "full_time", password: "temp12345"
        }
      }
    end

    candidate.reload
    assert candidate.stage_hired?
    assert_equal candidate.email, candidate.hired_employee.work_email
    assert_redirected_to job_opening_path(candidate.job_opening)
  end

  test "manager is forbidden from hiring" do
    sign_in employees(:manager_jane)
    candidate = job_candidates(:maria_offer)

    assert_no_difference "Employee.count" do
      post hire_job_candidate_path(candidate), params: {
        employee: { department: "Engineering", start_date: Date.current, employment_type: "full_time", password: "temp12345" }
      }
    end

    assert_redirected_to root_path
  end

  private

  def sign_in(employee)
    post session_path, params: { work_email: employee.work_email, password: "password" }
  end
end
