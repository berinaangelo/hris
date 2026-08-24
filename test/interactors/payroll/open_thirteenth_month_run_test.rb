require "test_helper"

module Payroll
  class OpenThirteenthMonthRunTest < ActiveSupport::TestCase
    test "opens a run and generates a payslip for every payable employee" do
      result = Payroll::OpenThirteenthMonthRun.call(
        company: companies(:acme), period_start: Date.current.beginning_of_year,
        period_end: Date.current.end_of_year, pay_date: Date.current
      )

      assert result.success?
      payroll_run = result.payroll_run
      assert payroll_run.thirteenth_month?
      assert_equal companies(:acme).employees.where.not(status: :offboarded).count, payroll_run.payslips.count
    end

    test "fails when the company toggle is off" do
      companies(:acme).update!(thirteenth_month_pay_enabled: false)

      result = Payroll::OpenThirteenthMonthRun.call(
        company: companies(:acme), period_start: Date.current.beginning_of_year,
        period_end: Date.current.end_of_year, pay_date: Date.current
      )

      assert result.failure?
      assert_match(/disabled/, result.message)
    end

    test "fails when a run is already open" do
      Payroll::OpenRun.call(company: companies(:acme), period_start: Date.current.beginning_of_month,
                             period_end: Date.current.end_of_month, pay_date: Date.current)

      result = Payroll::OpenThirteenthMonthRun.call(
        company: companies(:acme), period_start: Date.current.beginning_of_year,
        period_end: Date.current.end_of_year, pay_date: Date.current
      )

      assert result.failure?
      assert_match(/already open/, result.message)
    end
  end
end
