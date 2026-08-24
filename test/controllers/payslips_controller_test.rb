require "test_helper"

class PayslipsControllerTest < ActionDispatch::IntegrationTest
  setup do
    payroll_run = Payroll::OpenRun.call(company: companies(:acme), period_start: Date.current.beginning_of_month,
                                         period_end: Date.current.end_of_month, pay_date: Date.current).payroll_run
    Payroll::FinalizeRun.call(payroll_run: payroll_run, finalized_by: employees(:admin_amy))
    @payslip = payroll_run.payslips.find_by(employee: employees(:worker_bob))
  end

  test "an employee can list their own finalized payslips" do
    sign_in employees(:worker_bob)

    get payslips_path

    assert_response :success
  end

  test "an employee can view their own payslip" do
    sign_in employees(:worker_bob)

    get payslip_path(@payslip)

    assert_response :success
  end

  test "an employee cannot view someone else's payslip" do
    sign_in employees(:worker_carol)

    get payslip_path(@payslip)

    assert_response :not_found
  end

  private

  def sign_in(employee)
    post session_path, params: { work_email: employee.work_email, password: "password" }
  end
end
