require "test_helper"

module JobCandidates
  class SubmitApplicationTest < ActiveJob::TestCase
    test "creates a candidate and notifies the company's admins" do
      job_opening = job_openings(:acme_engineer_opening)

      assert_enqueued_jobs 1, only: NewCandidateNotifierJob do
        result = JobCandidates::SubmitApplication.call(
          job_opening: job_opening, candidate_params: { full_name: "New Applicant", email: "applicant@example.com" }, consent: true
        )

        assert result.success?
        assert result.candidate.consent_given_at.present?
      end
    end

    test "fails without raising when consent is not given" do
      job_opening = job_openings(:acme_engineer_opening)

      assert_no_difference "JobCandidate.count" do
        result = JobCandidates::SubmitApplication.call(
          job_opening: job_opening, candidate_params: { full_name: "New Applicant", email: "applicant@example.com" }, consent: false
        )

        assert result.failure?
      end
    end
  end
end
