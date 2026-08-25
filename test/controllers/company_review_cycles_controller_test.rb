require "test_helper"

class CompanyReviewCyclesControllerTest < ActionDispatch::IntegrationTest
  test "admin can view the company-wide roster" do
    sign_in employees(:admin_amy)

    get company_review_cycles_path

    assert_response :success
  end

  test "manager is forbidden" do
    sign_in employees(:manager_jane)

    get company_review_cycles_path

    assert_redirected_to root_path
  end

  test "plain employee is forbidden" do
    sign_in employees(:worker_bob)

    get company_review_cycles_path

    assert_redirected_to root_path
  end

  test "admin can view an employee's review detail" do
    sign_in employees(:admin_amy)

    get company_review_cycle_path(employees(:worker_bob))

    assert_response :success
  end

  test "admin cannot reach another company's employee" do
    sign_in employees(:admin_gary)

    get company_review_cycle_path(employees(:worker_bob))

    assert_response :not_found
  end

  test "admin can start a new cycle for an employee" do
    sign_in employees(:admin_amy)
    employee = employees(:worker_bob)

    assert_difference "ReviewCycle.count", 1 do
      post company_review_cycles_path, params: {
        review_cycle: { employee_id: employee.id, cycle_type: "regular", start_date: Date.current, end_date: 6.months.from_now.to_date },
        kpi_entries: [
          { kpi_name: "Ship feature X", target: "By Q3" },
          { kpi_name: "Reduce bugs", target: "Under 5 open" },
          { kpi_name: "Mentor a junior", target: "Weekly 1:1s" }
        ]
      }
    end

    assert_redirected_to company_review_cycles_path
  end

  test "admin can bulk-open shell cycles for a department" do
    sign_in employees(:admin_amy)

    assert_difference "ReviewCycle.count", 5 do # active Engineering: manager_jane, manager_optout, worker_bob, worker_optout, worker_carol
      post company_review_cycles_path, params: {
        scope: "department",
        review_cycle: { department: "Engineering", cycle_type: "regular", start_date: Date.current, end_date: 6.months.from_now.to_date }
      }
    end

    assert_redirected_to company_review_cycles_path
    assert ReviewCycle.last.kpi_entries.empty?
  end

  test "admin can bulk-open shell cycles company-wide" do
    sign_in employees(:admin_amy)

    assert_difference "ReviewCycle.count", 6 do # every active acme employee
      post company_review_cycles_path, params: {
        scope: "company",
        review_cycle: { cycle_type: "regular", start_date: Date.current, end_date: 6.months.from_now.to_date }
      }
    end

    assert_redirected_to company_review_cycles_path
  end

  test "bulk-opening a department does not notify employees" do
    sign_in employees(:admin_amy)

    assert_no_enqueued_jobs only: CycleOpenedNotifierJob do
      post company_review_cycles_path, params: {
        scope: "department",
        review_cycle: { department: "Engineering", cycle_type: "regular", start_date: Date.current, end_date: 6.months.from_now.to_date }
      }
    end
  end

  private

  def sign_in(employee)
    post session_path, params: { work_email: employee.work_email, password: "password" }
  end
end
