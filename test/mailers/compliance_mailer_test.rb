require "test_helper"

class ComplianceMailerTest < ActionMailer::TestCase
  test "expiring_certifications_digest_email goes to the admin's work email" do
    admin = employees(:admin_amy)
    certification = certifications(:carol_forklift_expiring_soon)

    email = ComplianceMailer.expiring_certifications_digest_email(admin, [ certification ])

    assert_equal [ admin.work_email ], email.to
    assert_match "1 certification", email.subject
    assert_match certification.employee.full_name, email.body.to_s
    assert_match "Forklift Operator License", email.body.to_s
  end
end
