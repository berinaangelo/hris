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
        brackets: [
          { min: "0", max: "4249.99", employee_share: "180.00", employer_share: "380.00" },
          { min: "4250.00", max: "", employee_share: "202.50", employer_share: "427.50" }
        ]
      }
    }

    assert_redirected_to rate_tables_path
    rate_table.reload
    assert_equal 2, rate_table.brackets.size
    assert_nil rate_table.brackets.last["max"]
  end

  test "blank effective date re-renders the index with the drawer open" do
    sign_in employees(:admin_amy)
    rate_table = rate_tables(:sss_acme)

    patch rate_table_path(rate_table), params: {
      rate_table: { effective_date: "", brackets: [ { min: "0", max: "", employee_share: "180.00", employer_share: "380.00" } ] }
    }

    assert_response :unprocessable_entity
  end

  test "a fully blank extra bracket row is dropped, not saved" do
    sign_in employees(:admin_amy)
    rate_table = rate_tables(:sss_acme)

    patch rate_table_path(rate_table), params: {
      rate_table: {
        effective_date: Date.current,
        brackets: [
          { min: "0", max: "", employee_share: "180.00", employer_share: "380.00" },
          { min: "", max: "", employee_share: "", employer_share: "" }
        ]
      }
    }

    assert_redirected_to rate_tables_path
    assert_equal 1, rate_table.reload.brackets.size
  end

  test "admin cannot reach another company's rate table" do
    sign_in employees(:admin_gary)

    patch rate_table_path(rate_tables(:sss_acme)), params: { rate_table: { effective_date: Date.current } }

    assert_response :not_found
  end

  private

  def sign_in(employee)
    post session_path, params: { work_email: employee.work_email, password: "password" }
  end
end
