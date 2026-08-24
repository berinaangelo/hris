require "test_helper"

module Payroll
  class RecomputePayslipTotalsTest < ActiveSupport::TestCase
    test "sums earnings and deductions into gross/net" do
      payroll_run = PayrollRun.create!(company: companies(:acme), period_start: Date.current.beginning_of_month,
                                        period_end: Date.current.end_of_month, pay_date: Date.current, run_type: :regular)
      payslip = Payslip.create!(payroll_run: payroll_run, employee: employees(:worker_bob), status: :draft)
      payslip.payslip_line_items.create!(line_type: :base_salary, direction: :earning, source: :base, amount: 20_000)
      payslip.payslip_line_items.create!(line_type: :statutory_sss, direction: :deduction, source: :statutory, amount: 200)

      result = Payroll::RecomputePayslipTotals.call(payslip: payslip)

      assert result.success?
      payslip.reload
      assert_equal 20_000, payslip.gross_pay
      assert_equal 200, payslip.total_deductions
      assert_equal 19_800, payslip.net_pay
    end
  end
end
