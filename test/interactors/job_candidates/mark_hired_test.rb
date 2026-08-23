require "test_helper"

module JobCandidates
  class MarkHiredTest < ActiveSupport::TestCase
    test "creates an employee record and links it to the candidate" do
      candidate = job_candidates(:maria_offer)

      result = JobCandidates::MarkHired.call(
        job_candidate: candidate,
        company: candidate.job_opening.company,
        employee_params: {
          first_name: "Maria", last_name: "Santos", work_email: candidate.email, personal_email: candidate.email,
          job_title: "Engineer", department: "Engineering", start_date: Date.current, employment_type: "full_time",
          password: "temp12345"
        }
      )

      assert result.success?
      candidate.reload
      assert candidate.stage_hired?
      assert_equal result.employee, candidate.hired_employee
    end

    test "fails without raising and does not link the candidate when employee creation fails" do
      candidate = job_candidates(:maria_offer)

      result = JobCandidates::MarkHired.call(
        job_candidate: candidate,
        company: candidate.job_opening.company,
        employee_params: {
          first_name: "", last_name: "Santos", work_email: candidate.email, personal_email: candidate.email,
          job_title: "Engineer", department: "Engineering", start_date: Date.current, employment_type: "full_time",
          password: "temp12345"
        }
      )

      assert result.failure?
      assert_not candidate.reload.stage_hired?
    end
  end
end
