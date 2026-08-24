require "test_helper"

class PasswordsControllerTest < ActionDispatch::IntegrationTest
  test "update with the correct current password changes it and redirects to account settings" do
    employee = employees(:worker_bob)
    sign_in employee

    patch password_path, params: { current_password: "password", new_password: "a-new-password", new_password_confirmation: "a-new-password" }

    assert_redirected_to account_settings_path
    assert employee.reload.authenticate("a-new-password")
  end

  test "update with the wrong current password re-renders account settings with the modal forced open" do
    employee = employees(:worker_bob)
    sign_in employee

    patch password_path, params: { current_password: "wrong", new_password: "a-new-password", new_password_confirmation: "a-new-password" }

    assert_response :unprocessable_entity
    assert_select "[data-modal-open-value=?]", "true"
    assert_select ".field-error", text: "Current password is incorrect."
    assert_not employee.reload.authenticate("a-new-password")
  end

  private

  def sign_in(employee)
    post session_path, params: { work_email: employee.work_email, password: "password" }
  end
end
