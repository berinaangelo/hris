require "test_helper"

class ReportsControllerTest < ActionDispatch::IntegrationTest
  test "admin can view the reports landing page" do
    sign_in employees(:admin_amy)

    get reports_path

    assert_response :success
  end

  test "manager is forbidden" do
    sign_in employees(:manager_jane)

    get reports_path

    assert_redirected_to root_path
  end

  test "plain employee is forbidden" do
    sign_in employees(:worker_bob)

    get reports_path

    assert_redirected_to root_path
  end

  test "unknown report key 404s" do
    sign_in employees(:admin_amy)

    get report_path("not-a-real-report")

    assert_response :not_found
  end

  test "headcount snapshot shows active acme employees by department" do
    sign_in employees(:admin_amy)

    get report_path("headcount-snapshot"), params: { as_of: Date.current }

    assert_response :success
    assert_match "Engineering", response.body
  end

  test "headcount snapshot can be filtered by department" do
    sign_in employees(:admin_amy)

    get report_path("headcount-snapshot"), params: { as_of: Date.current, department: "People" }

    assert_response :success
    assert_match "<td>People</td>", response.body
    assert_no_match "<td>Engineering</td>", response.body
  end

  test "new hires vs departures over a wide range counts hires and no departures" do
    sign_in employees(:admin_amy)

    get report_path("new-hires-vs-departures"), params: { start_date: "2019-01-01", end_date: "2026-12-31" }

    assert_response :success
    assert_match "Engineering", response.body
  end

  test "turnover count over a wide range with no departures shows nothing" do
    sign_in employees(:admin_amy)

    get report_path("turnover-count"), params: { start_date: "2019-01-01", end_date: "2026-12-31" }

    assert_response :success
    assert_match "No data for this filter.", response.body
  end

  test "leave balances shows entitled/used/remaining per employee" do
    sign_in employees(:admin_amy)

    get report_path("leave-balances"), params: { year: 2026 }

    assert_response :success
    assert_match "Bob Worker", response.body
  end

  test "leave balances can be filtered by department" do
    sign_in employees(:admin_amy)

    get report_path("leave-balances"), params: { year: 2026, department: "Engineering" }
    assert_response :success
    assert_match "Bob Worker", response.body

    get report_path("leave-balances"), params: { year: 2026, department: "People" }
    assert_response :success
    assert_match "No data for this filter.", response.body
  end

  test "leave taken summary sums approved days by department over a range" do
    sign_in employees(:admin_amy)

    get report_path("leave-taken-summary"), params: { start_date: "2026-09-01", end_date: "2026-09-03" }

    assert_response :success
    assert_match "Engineering", response.body
  end

  test "leave taken summary can be filtered by department" do
    sign_in employees(:admin_amy)

    get report_path("leave-taken-summary"), params: { start_date: "2026-09-01", end_date: "2026-09-03", department: "Engineering" }
    assert_response :success
    assert_match "Engineering", response.body

    get report_path("leave-taken-summary"), params: { start_date: "2026-09-01", end_date: "2026-09-03", department: "People" }
    assert_response :success
    assert_match "No data for this filter.", response.body
  end

  test "payroll register lists payslips for the selected cutoff" do
    sign_in employees(:admin_amy)

    get report_path("payroll-register"), params: { payroll_run_id: payroll_runs(:acme_september_2026).id }

    assert_response :success
    assert_match "Bob Worker", response.body
    assert_match "Carol Reports", response.body
  end

  test "payroll register can be filtered by department" do
    sign_in employees(:admin_amy)

    get report_path("payroll-register"), params: { payroll_run_id: payroll_runs(:acme_september_2026).id, department: "Engineering" }
    assert_response :success
    assert_match "Bob Worker", response.body

    get report_path("payroll-register"), params: { payroll_run_id: payroll_runs(:acme_september_2026).id, department: "People" }
    assert_response :success
    assert_match "No data for this filter.", response.body
  end

  test "statutory contributions summary aggregates by contribution type" do
    sign_in employees(:admin_amy)

    get report_path("statutory-contributions-summary"), params: { payroll_run_id: payroll_runs(:acme_september_2026).id }

    assert_response :success
    assert_match "Statutory sss", response.body
  end

  test "admin can export a report as csv" do
    sign_in employees(:admin_amy)

    get report_path("payroll-register", format: :csv), params: { payroll_run_id: payroll_runs(:acme_september_2026).id }

    assert_response :success
    assert_equal "text/csv", response.media_type
    assert_match "Bob Worker", response.body
  end

  test "reports are scoped to the admin's own company" do
    sign_in employees(:admin_gary) # globex

    get report_path("payroll-register"), params: { payroll_run_id: payroll_runs(:acme_september_2026).id }

    assert_response :success
    assert_match "No data for this filter.", response.body
  end

  private

  def sign_in(employee)
    post session_path, params: { work_email: employee.work_email, password: "password" }
  end
end
