require "test_helper"

class RateTablesControllerTest < ActionDispatch::IntegrationTest
  test "admin can view the list" do
    sign_in employees(:admin_amy)

    get rate_tables_path

    assert_response :success
  end

  test "manager is forbidden" do
    sign_in employees(:manager_jane)

    get rate_tables_path
    assert_redirected_to root_path
  end

  test "plain employee is forbidden" do
    sign_in employees(:worker_bob)

    get rate_tables_path
    assert_redirected_to root_path
  end

  test "admin can update a rate table" do
    sign_in employees(:admin_amy)
    rate_table = rate_tables(:sss_acme)

    patch rate_table_path(rate_table), params: {
      rate_table: {
        effective_date: 1.day.ago.to_date,
        brackets_json: rate_table.brackets.to_json,
        fields_json: nil
      }
    }

    assert_redirected_to rate_tables_path
  end

  test "invalid JSON re-renders the edit form" do
    sign_in employees(:admin_amy)
    rate_table = rate_tables(:sss_acme)

    patch rate_table_path(rate_table), params: {
      rate_table: { effective_date: Date.current, brackets_json: "not json", fields_json: nil }
    }

    assert_response :unprocessable_entity
  end

  test "admin cannot reach another company's rate table" do
    sign_in employees(:admin_gary)

    get edit_rate_table_path(rate_tables(:sss_acme))

    assert_response :not_found
  end

  private

  def sign_in(employee)
    post session_path, params: { work_email: employee.work_email, password: "password" }
  end
end
