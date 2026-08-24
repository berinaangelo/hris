require "test_helper"

class LeaveRequestsControllerTest < ActionDispatch::IntegrationTest
  test "index renders the request history with the modal closed" do
    sign_in employees(:worker_bob)

    get leave_requests_path

    assert_response :success
    assert_select "div[data-modal-open-value=?]", "false"
    assert_select "table.reqtable tr", minimum: 1
  end

  test "new renders index with the modal forced open" do
    sign_in employees(:worker_bob)

    get new_leave_request_path

    assert_response :success
    assert_select "div[data-modal-open-value=?]", "true"
  end

  test "create succeeds and redirects to the history" do
    sign_in employees(:worker_bob)

    assert_difference "LeaveRequest.count", 1 do
      post leave_requests_path, params: {
        leave_request: {
          leave_type_id: leave_types(:vacation).id, start_date: Date.new(2026, 11, 1),
          end_date: Date.new(2026, 11, 3), days_requested: 3, reason: "Trip"
        }
      }
    end

    assert_redirected_to leave_requests_path
  end

  test "create with an invalid date range re-renders index with the modal open and an inline error" do
    sign_in employees(:worker_bob)

    assert_no_difference "LeaveRequest.count" do
      post leave_requests_path, params: {
        leave_request: {
          leave_type_id: leave_types(:vacation).id, start_date: Date.new(2026, 11, 5),
          end_date: Date.new(2026, 11, 1), days_requested: 1, reason: nil
        }
      }
    end

    assert_response :unprocessable_entity
    assert_select "div[data-modal-open-value=?]", "true"
    assert_select ".field-error", text: "can't be before the start date"
  end

  test "create with an overlapping range re-renders index with the modal open and an inline error" do
    sign_in employees(:worker_bob)
    overlapping = leave_requests(:bob_pending)

    assert_no_difference "LeaveRequest.count" do
      post leave_requests_path, params: {
        leave_request: {
          leave_type_id: leave_types(:vacation).id, start_date: overlapping.start_date,
          end_date: overlapping.end_date, days_requested: overlapping.days_requested, reason: nil
        }
      }
    end

    assert_response :unprocessable_entity
    assert_select "div[data-modal-open-value=?]", "true"
    assert_select ".field-error", text: "Overlaps a request you've already submitted"
  end

  private

  def sign_in(employee)
    post session_path, params: { work_email: employee.work_email, password: "password" }
  end
end
