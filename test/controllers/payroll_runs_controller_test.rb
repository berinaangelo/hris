require "test_helper"

class PayrollRunsControllerTest < ActionDispatch::IntegrationTest
  test "admin can view the list" do
    sign_in employees(:admin_amy)

    get payroll_runs_path

    assert_response :success
  end

  test "manager is forbidden" do
    sign_in employees(:manager_jane)

    get payroll_runs_path
    assert_redirected_to root_path
  end

  test "plain employee is forbidden" do
    sign_in employees(:worker_bob)

    get payroll_runs_path
    assert_redirected_to root_path
  end

  test "run history is paginated" do
    sign_in employees(:admin_amy)

    get payroll_runs_path

    assert_response :success
    assert_match "pagination-bar", response.body
  end

  test "admin can export a run as csv" do
    sign_in employees(:admin_amy)

    get payroll_run_path(payroll_runs(:acme_september_2026), format: :csv)

    assert_response :success
    assert_equal "text/csv", response.media_type
    assert_match "Bob Worker", response.body
    # Bob's fixture adjustments: +2000 bonus, -500 cash advance = net 1500 —
    # exercises PayslipPresenter#adjustments_total's signed sum.
    assert_match "1500.0", response.body
  end

  test "admin can open a payroll run" do
    sign_in employees(:admin_amy)

    assert_difference "PayrollRun.count", 1 do
      post payroll_runs_path, params: {
        period_start: Date.current.beginning_of_month, period_end: Date.current.end_of_month, pay_date: Date.current
      }
    end

    assert_redirected_to payroll_run_path(PayrollRun.last)
  end

  test "opening a run fails and re-renders when one is already open" do
    sign_in employees(:admin_amy)
    Payroll::OpenRun.call(company: companies(:acme), period_start: Date.current.beginning_of_month,
                           period_end: Date.current.end_of_month, pay_date: Date.current)

    assert_no_difference "PayrollRun.count" do
      post payroll_runs_path, params: {
        period_start: Date.current.beginning_of_month, period_end: Date.current.end_of_month, pay_date: Date.current
      }
    end

    assert_response :unprocessable_entity
  end

  test "admin can view and finalize a run" do
    sign_in employees(:admin_amy)
    payroll_run = Payroll::OpenRun.call(company: companies(:acme), period_start: Date.current.beginning_of_month,
                                         period_end: Date.current.end_of_month, pay_date: Date.current).payroll_run

    get payroll_run_path(payroll_run)
    assert_response :success

    patch finalize_payroll_run_path(payroll_run)
    assert_redirected_to payroll_run_path(payroll_run)
    assert payroll_run.reload.finalized?
  end

  test "admin can open a 13th month run" do
    sign_in employees(:admin_amy)

    assert_difference "PayrollRun.count", 1 do
      post payroll_runs_path, params: {
        run_type: "thirteenth_month", period_start: Date.current.beginning_of_year,
        period_end: Date.current.end_of_year, pay_date: Date.current
      }
    end

    assert_equal "thirteenth_month", PayrollRun.last.run_type
  end

  test "opening a 13th month run fails cleanly when the company toggle is off" do
    sign_in employees(:admin_amy)
    companies(:acme).update!(thirteenth_month_pay_enabled: false)

    assert_no_difference "PayrollRun.count" do
      post payroll_runs_path, params: {
        run_type: "thirteenth_month", period_start: Date.current.beginning_of_year,
        period_end: Date.current.end_of_year, pay_date: Date.current
      }
    end

    assert_response :unprocessable_entity
  end

  test "admin cannot reach another company's payroll run" do
    sign_in employees(:admin_gary)
    payroll_run = Payroll::OpenRun.call(company: companies(:acme), period_start: Date.current.beginning_of_month,
                                         period_end: Date.current.end_of_month, pay_date: Date.current).payroll_run

    get payroll_run_path(payroll_run)

    assert_response :not_found
  end

  private

  def sign_in(employee)
    post session_path, params: { work_email: employee.work_email, password: "password" }
  end
end
