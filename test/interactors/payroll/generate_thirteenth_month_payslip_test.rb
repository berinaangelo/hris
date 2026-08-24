require "test_helper"

module Payroll
  class GenerateThirteenthMonthPayslipTest < ActiveSupport::TestCase
    test "computes pay as this year's finalized base_salary earnings over 12" do
      regular_run = open_and_finalize_regular_run
      thirteenth_month_run = new_thirteenth_month_run

      result = Payroll::GenerateThirteenthMonthPayslip.call(employee: employees(:worker_optout), payroll_run: thirteenth_month_run)

      assert result.success?
      base_earned = regular_run.payslips.find_by(employee: employees(:worker_optout))
                               .payslip_line_items.find_by(line_type: :base_salary).amount
      expected = (base_earned / 12).round(2)
      line_item = result.payslip.payslip_line_items.find_by(line_type: :thirteenth_month_pay)

      assert_equal expected, line_item.amount
      assert_equal expected, result.payslip.gross_pay
      assert_equal expected, result.payslip.net_pay
    end

    test "only a reissue's line items count once the original is voided" do
      regular_run = open_and_finalize_regular_run
      original = regular_run.payslips.find_by(employee: employees(:worker_optout))
      reissue = Payroll::VoidAndReissuePayslip.call(payslip: original, void_reason: "correction").new_payslip
      Payroll::FinalizePayslip.call(payslip: reissue, finalized_by: employees(:admin_amy))

      result = Payroll::GenerateThirteenthMonthPayslip.call(employee: employees(:worker_optout), payroll_run: new_thirteenth_month_run)

      base_earned = reissue.payslip_line_items.find_by(line_type: :base_salary).amount
      expected = (base_earned / 12).round(2)
      assert_equal expected, result.payslip.payslip_line_items.find_by(line_type: :thirteenth_month_pay).amount
    end

    test "an employee with no finalized payslips this year gets no line item" do
      result = Payroll::GenerateThirteenthMonthPayslip.call(employee: employees(:worker_optout), payroll_run: new_thirteenth_month_run)

      assert result.success?
      assert_empty result.payslip.payslip_line_items
      assert_equal 0, result.payslip.net_pay
    end

    private

    def open_and_finalize_regular_run
      run = Payroll::OpenRun.call(company: companies(:acme), period_start: Date.current.beginning_of_month,
                                   period_end: Date.current.end_of_month, pay_date: Date.current).payroll_run
      Payroll::FinalizeRun.call(payroll_run: run, finalized_by: employees(:admin_amy))
      run
    end

    def new_thirteenth_month_run
      PayrollRun.create!(company: companies(:acme), period_start: Date.current.beginning_of_year,
                          period_end: Date.current.end_of_year, pay_date: Date.current, run_type: :thirteenth_month)
    end
  end
end
