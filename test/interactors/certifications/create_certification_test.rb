require "test_helper"

module Certifications
  class CreateCertificationTest < ActiveSupport::TestCase
    test "creates a certification for the given employee" do
      employee = employees(:worker_bob)

      result = Certifications::CreateCertification.call(
        employee: employee,
        certification_params: { cert_name: "Safety Officer", expiry_date: 1.year.from_now.to_date }
      )

      assert result.success?
      assert_equal employee, result.certification.employee
    end

    test "fails when the employee is missing" do
      result = Certifications::CreateCertification.call(
        employee: nil,
        certification_params: { cert_name: "Safety Officer", expiry_date: 1.year.from_now.to_date }
      )

      assert result.failure?
    end

    test "fails validation with a blank cert name" do
      employee = employees(:worker_bob)

      result = Certifications::CreateCertification.call(
        employee: employee,
        certification_params: { cert_name: "", expiry_date: 1.year.from_now.to_date }
      )

      assert result.failure?
    end
  end
end
