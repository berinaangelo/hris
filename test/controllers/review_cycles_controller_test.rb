require "test_helper"

class ReviewCyclesControllerTest < ActionDispatch::IntegrationTest
  test "employee can view their own review history" do
    sign_in employees(:worker_bob)

    get review_cycles_path

    assert_response :success
  end

  test "employee cannot reach a teammate's cycle" do
    sign_in employees(:worker_bob)

    get review_cycles_path(cycle_id: review_cycles(:alice_awaiting_scoring).id)

    assert_response :not_found
  end

  private

  def sign_in(employee)
    post session_path, params: { work_email: employee.work_email, password: "password" }
  end
end
