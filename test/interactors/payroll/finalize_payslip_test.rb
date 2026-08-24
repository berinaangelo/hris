require "test_helper"

module Payroll
  class FinalizePayslipTest < ActiveSupport::TestCase
    setup do
      @payroll_run = Payroll::OpenRun.call(
        company: companies(:acme), period_start: Date.current.beginning_of_month,
        period_end: Date.current.end_of_month, pay_date: Date.current
      ).payroll_run
      Payroll::FinalizeRun.call(payroll_run: @payroll_run, finalized_by: employees(:admin_amy))
      original_payslip = @payroll_run.payslips.find_by(employee: employees(:worker_bob))
      @reissue = Payroll::VoidAndReissuePayslip.call(payslip: original_payslip, void_reason: "correction").new_payslip
    end

    test "finalizes a draft payslip" do
      result = Payroll::FinalizePayslip.call(payslip: @reissue, finalized_by: employees(:admin_amy))

      assert result.success?
      @reissue.reload
      assert @reissue.finalized?
      assert_equal employees(:admin_amy), @reissue.generated_by
      assert_not_nil @reissue.generated_at
    end

    test "finalizing twice is idempotent" do
      Payroll::FinalizePayslip.call(payslip: @reissue, finalized_by: employees(:admin_amy))
      generated_at_first = @reissue.reload.generated_at

      result = Payroll::FinalizePayslip.call(payslip: @reissue, finalized_by: employees(:admin_amy))

      assert result.success?
      assert_equal generated_at_first, @reissue.reload.generated_at
    end

    test "does not touch loan installments" do
      remaining_before = loans(:bob_company_loan).remaining_installments

      Payroll::FinalizePayslip.call(payslip: @reissue, finalized_by: employees(:admin_amy))

      assert_equal remaining_before, loans(:bob_company_loan).reload.remaining_installments
    end

    test "fails on a voided payslip" do
      original_payslip = @reissue.previous_version

      result = Payroll::FinalizePayslip.call(payslip: original_payslip, finalized_by: employees(:admin_amy))

      assert result.failure?
    end
  end
end
