require "test_helper"

class MyProfileControllerTest < ActionDispatch::IntegrationTest
  test "show renders the summary, onboarding checklist, and documents" do
    sign_in employees(:worker_bob)

    get my_profile_path

    assert_response :success
    assert_select "h2", text: employees(:worker_bob).full_name
    assert_select "h3", text: "Onboarding checklist"
    assert_select "[data-modal-open-value=?]", "false"
  end

  test "update with valid params saves and redirects" do
    employee = employees(:worker_bob)
    sign_in employee

    patch my_profile_path, params: { employee: { mobile_number: "0917 000 0000" } }

    assert_redirected_to my_profile_path
    assert_equal "0917 000 0000", employee.reload.mobile_number
  end

  private

  def sign_in(employee)
    post session_path, params: { work_email: employee.work_email, password: "password" }
  end
end
