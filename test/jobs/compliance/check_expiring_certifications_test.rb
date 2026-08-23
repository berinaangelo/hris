require "test_helper"

module Compliance
  class CheckExpiringCertificationsTest < ActiveJob::TestCase
    include ActionMailer::TestHelper

    test "sends one digest to each opted-in admin whose company has an expiring-soon certification" do
      # acme's admin_amy is opted in (default); globex's admin_gary is
      # opted out (see test/fixtures/employees.yml) — only acme's digest
      # should go out even though both companies have an expiring cert.
      assert_emails 1 do
        Compliance::CheckExpiringCertifications.perform_now
      end

      email = ActionMailer::Base.deliveries.last
      assert_equal [ employees(:admin_amy).work_email ], email.to
    end

    test "does not include an already-expired certification in the digest" do
      Compliance::CheckExpiringCertifications.perform_now

      email = ActionMailer::Base.deliveries.last
      assert_no_match "CPR Certification", email.body.to_s
      assert_match "Forklift Operator License", email.body.to_s
    end

    test "does not email an admin who opted out" do
      Compliance::CheckExpiringCertifications.perform_now

      assert_not ActionMailer::Base.deliveries.any? { |mail| mail.to == [ employees(:admin_gary).work_email ] }
    end
  end
end
