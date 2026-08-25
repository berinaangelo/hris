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

  test "an employee with no finalized payslips sees the empty state" do
    sign_in employees(:worker_diane) # globex — no payroll run opened for that company

    get payslips_path

    assert_response :success
    assert_match "No payslips yet", response.body
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

  test "an admin can view any payslip in their company" do
    sign_in employees(:admin_amy)

    get payslip_path(@payslip)

    assert_response :success
  end

  test "an admin cannot view another company's payslip" do
    sign_in employees(:admin_gary)

    get payslip_path(@payslip)

    assert_response :not_found
  end

  test "an admin's own payslips index still only shows their own" do
    sign_in employees(:admin_amy)
    admin_payslip = PayrollRun.find(@payslip.payroll_run_id).payslips.find_by(employee: employees(:admin_amy))

    get payslips_path

    assert_response :success
    assert_select "a[href=?]", payslips_path(pinned_id: admin_payslip.id)
    assert_select "a[href=?]", payslips_path(pinned_id: @payslip.id), count: 0
  end

  test "index pins the most recent finalized payslip by default" do
    sign_in employees(:worker_bob)

    get payslips_path

    assert_response :success
    assert_select "turbo-frame#payslip_breakdown"
  end

  test "index pins a specific payslip via pinned_id" do
    sign_in employees(:worker_bob)

    get payslips_path(pinned_id: @payslip.id)

    assert_response :success
    assert_select "turbo-frame#payslip_breakdown"
  end

  test "viewing own payslip marks it viewed" do
    sign_in employees(:worker_bob)
    assert_nil @payslip.viewed_at

    get payslip_path(@payslip)

    assert_not_nil @payslip.reload.viewed_at
  end

  test "admin can void and reissue a finalized payslip" do
    sign_in employees(:admin_amy)

    assert_difference "Payslip.count", 1 do
      patch void_and_reissue_payslip_path(@payslip), params: { void_reason: "Overtime was entered incorrectly" }
    end

    assert @payslip.reload.voided?
    assert_equal "Overtime was entered incorrectly", @payslip.void_reason
    reissue = @payslip.reissued_version
    assert reissue.draft?
    assert_equal @payslip.payslip_line_items.count, reissue.payslip_line_items.count
    assert_redirected_to payslip_path(reissue)
  end

  test "correction history timeline shows the voided version and the current reissue" do
    sign_in employees(:admin_amy)
    patch void_and_reissue_payslip_path(@payslip), params: { void_reason: "Overtime was entered incorrectly" }
    reissue = @payslip.reload.reissued_version
    reissue.update!(status: :finalized)

    get payslip_path(reissue)

    assert_response :success
    assert_match "Voided", response.body
    assert_match "Current", response.body
    assert_match "Overtime was entered incorrectly", response.body
  end

  test "void and reissue fails on a payslip that isn't finalized" do
    sign_in employees(:admin_amy)
    draft = Payslip.create!(payroll_run: @payslip.payroll_run, employee: employees(:worker_optout), status: :draft)

    assert_no_difference "Payslip.count" do
      patch void_and_reissue_payslip_path(draft), params: { void_reason: "irrelevant" }
    end

    assert_redirected_to payslip_path(draft)
  end

  test "a manager cannot void and reissue a payslip" do
    sign_in employees(:manager_jane)

    # Manager's policy_scope only contains their own payslips, so
    # someone else's payslip isn't even found — same 404 shape as a
    # plain employee peeking at a colleague's payslip.
    patch void_and_reissue_payslip_path(@payslip), params: { void_reason: "nope" }

    assert_response :not_found
    assert @payslip.reload.finalized?
  end

  test "admin can finalize a draft reissue" do
    sign_in employees(:admin_amy)
    patch void_and_reissue_payslip_path(@payslip), params: { void_reason: "correction" }
    reissue = @payslip.reload.reissued_version
    original_remaining = loans(:bob_company_loan).remaining_installments

    patch finalize_payslip_path(reissue)

    assert reissue.reload.finalized?
    assert_equal original_remaining, loans(:bob_company_loan).reload.remaining_installments
  end

  private

  def sign_in(employee)
    post session_path, params: { work_email: employee.work_email, password: "password" }
  end
end
