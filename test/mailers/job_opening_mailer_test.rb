require "test_helper"

class JobOpeningMailerTest < ActionMailer::TestCase
  test "new_candidate_email goes to the admin" do
    candidate = job_candidates(:juan_new)
    admin = employees(:admin_amy)

    email = JobOpeningMailer.new_candidate_email(candidate, admin)

    assert_equal [ admin.work_email ], email.to
    assert_match "New application", email.subject
    assert_match candidate.full_name, email.body.to_s
  end
end
