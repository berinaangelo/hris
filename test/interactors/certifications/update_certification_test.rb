require "test_helper"

module Certifications
  class UpdateCertificationTest < ActiveSupport::TestCase
    test "updates the certification's fields" do
      certification = certifications(:carol_forklift_expiring_soon)
      new_date = 2.years.from_now.to_date

      result = Certifications::UpdateCertification.call(
        certification: certification,
        employee: certification.employee,
        cert_name: "Forklift Operator License (Renewed)",
        expiry_date: new_date
      )

      assert result.success?
      certification.reload
      assert_equal "Forklift Operator License (Renewed)", certification.cert_name
      assert_equal new_date, certification.expiry_date
    end

    test "fails when the employee is missing" do
      certification = certifications(:carol_forklift_expiring_soon)

      result = Certifications::UpdateCertification.call(
        certification: certification,
        employee: nil,
        cert_name: certification.cert_name,
        expiry_date: certification.expiry_date
      )

      assert result.failure?
    end

    test "fails validation with a blank cert name" do
      certification = certifications(:carol_forklift_expiring_soon)

      result = Certifications::UpdateCertification.call(
        certification: certification,
        employee: certification.employee,
        cert_name: "",
        expiry_date: certification.expiry_date
      )

      assert result.failure?
    end
  end
end
