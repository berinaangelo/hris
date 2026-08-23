require "test_helper"

class CareersControllerTest < ActionDispatch::IntegrationTest
  test "anyone can view an open job opening's application form without signing in" do
    get careers_path(job_openings(:acme_engineer_opening).slug)

    assert_response :success
    assert_match "Software Engineer", response.body
  end

  test "a closed job opening 404s" do
    get careers_path(job_openings(:acme_closed_opening).slug)

    assert_response :not_found
  end

  test "an unknown slug 404s" do
    get careers_path("not-a-real-slug")

    assert_response :not_found
  end

  test "a visitor can submit an application" do
    assert_difference "JobCandidate.count", 1 do
      post careers_path(job_openings(:acme_engineer_opening).slug), params: {
        job_candidate: { full_name: "New Applicant", email: "applicant@example.com", phone: "0917", consent: "1" }
      }
    end

    assert_redirected_to careers_path(job_openings(:acme_engineer_opening).slug)
  end

  test "submitting without consent fails and does not create a candidate" do
    assert_no_difference "JobCandidate.count" do
      post careers_path(job_openings(:acme_engineer_opening).slug), params: {
        job_candidate: { full_name: "New Applicant", email: "applicant@example.com" }
      }
    end

    assert_response :unprocessable_entity
  end
end
