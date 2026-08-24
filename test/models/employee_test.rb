require "test_helper"

class EmployeeTest < ActiveSupport::TestCase
  test "a password_reset token is valid for the employee it was generated for" do
    employee = employees(:worker_bob)
    token = employee.generate_token_for(:password_reset)

    assert_equal employee, Employee.find_by_token_for(:password_reset, token)
  end

  test "a password_reset token is invalidated once the password changes" do
    employee = employees(:worker_bob)
    token = employee.generate_token_for(:password_reset)

    employee.update!(password: "a-new-password")

    assert_nil Employee.find_by_token_for(:password_reset, token)
  end

  test "an expired password_reset token no longer resolves" do
    employee = employees(:worker_bob)
    token = employee.generate_token_for(:password_reset)

    travel 16.minutes do
      assert_nil Employee.find_by_token_for(:password_reset, token)
    end
  end
end
