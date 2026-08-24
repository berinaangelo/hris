require "test_helper"

module Payroll
  class VoidAndReissuePayslipTest < ActiveSupport::TestCase
    setup do
      @payroll_run = Payroll::OpenRun.call(
        company: companies(:acme), period_start: Date.current.beginning_of_month,
        period_end: Date.current.end_of_month, pay_date: Date.current
      ).payroll_run
      Payroll::FinalizeRun.call(payroll_run: @payroll_run, finalized_by: employees(:admin_amy))
      @payslip = @payroll_run.payslips.find_by(employee: employees(:worker_bob))
    end

    test "voids the current payslip and creates a linked draft reissue with copied line items" do
      result = Payroll::VoidAndReissuePayslip.call(payslip: @payslip, void_reason: "OT missing")

      assert result.success?
      @payslip.reload
      assert @payslip.voided?
      assert_equal "OT missing", @payslip.void_reason

      reissue = result.new_payslip
      assert reissue.draft?
      assert_equal @payslip.id, reissue.previous_version_id
      assert_equal @payslip.payroll_run, reissue.payroll_run
      assert_equal @payslip.employee, reissue.employee
      assert_equal @payslip.payslip_line_items.count, reissue.payslip_line_items.count
      assert_equal @payslip.gross_pay, reissue.gross_pay
      assert_equal @payslip.net_pay, reissue.net_pay
    end

    test "copied line items are independent rows, not shared with the old payslip" do
      result = Payroll::VoidAndReissuePayslip.call(payslip: @payslip, void_reason: "correction")
      reissue = result.new_payslip

      original_ids = @payslip.payslip_line_items.pluck(:id)
      reissue_ids = reissue.payslip_line_items.pluck(:id)

      assert_empty (original_ids & reissue_ids)
    end

    test "fails when the payslip is not finalized" do
      draft = Payslip.create!(payroll_run: @payroll_run, employee: employees(:worker_optout), status: :draft)

      result = Payroll::VoidAndReissuePayslip.call(payslip: draft, void_reason: "n/a")

      assert result.failure?
      assert_equal "draft", draft.reload.status
    end

    test "fails when the payslip is already voided" do
      Payroll::VoidAndReissuePayslip.call(payslip: @payslip, void_reason: "first correction")

      result = Payroll::VoidAndReissuePayslip.call(payslip: @payslip.reload, void_reason: "second attempt")

      assert result.failure?
    end
  end
end
