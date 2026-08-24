require "test_helper"

module Payroll
  class FinalizeRunTest < ActiveSupport::TestCase
    setup do
      @company = companies(:acme)
      @admin = employees(:admin_amy)
      open_result = Payroll::OpenRun.call(
        company: @company, period_start: Date.current.beginning_of_month,
        period_end: Date.current.end_of_month, pay_date: Date.current
      )
      @payroll_run = open_result.payroll_run
    end

    test "finalizes every draft payslip and stamps the run" do
      result = Payroll::FinalizeRun.call(payroll_run: @payroll_run, finalized_by: @admin)

      assert result.success?
      @payroll_run.reload
      assert @payroll_run.finalized?
      assert_equal @admin, @payroll_run.finalized_by
      assert @payroll_run.payslips.reload.all?(&:finalized?)
    end

    test "decrements an active loan's installments and marks it paid off at zero" do
      loan = loans(:carol_pagibig_mpl_last_installment) # remaining_installments: 1

      Payroll::FinalizeRun.call(payroll_run: @payroll_run, finalized_by: @admin)

      loan.reload
      assert_equal 0, loan.remaining_installments
      assert loan.paid_off?
    end

    test "finalizing twice is idempotent — installments only decrement once" do
      loan = loans(:bob_company_loan) # remaining_installments: 12

      Payroll::FinalizeRun.call(payroll_run: @payroll_run, finalized_by: @admin)
      Payroll::FinalizeRun.call(payroll_run: @payroll_run, finalized_by: @admin)

      assert_equal 11, loan.reload.remaining_installments
    end
  end
end
