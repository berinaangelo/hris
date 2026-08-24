require "test_helper"

module Payroll
  class OpenRunTest < ActiveSupport::TestCase
    setup do
      @company = companies(:acme)
      @params = { period_start: Date.current.beginning_of_month, period_end: Date.current.end_of_month, pay_date: Date.current }
    end

    test "opens a run and generates a draft payslip for every payable employee" do
      result = Payroll::OpenRun.call(company: @company, **@params)

      assert result.success?
      payroll_run = result.payroll_run
      assert payroll_run.open?
      # Every acme employee not offboarded (worker_offboarding is still mid-offboarding, still payable).
      assert_equal @company.employees.where.not(status: :offboarded).count, payroll_run.payslips.count
    end

    test "fails when a run is already open for the company" do
      Payroll::OpenRun.call(company: @company, **@params)

      result = Payroll::OpenRun.call(company: @company, **@params)

      assert result.failure?
      assert_match(/already open/, result.message)
    end

    test "fails and names employees missing a basic salary, creating nothing" do
      employees(:worker_bob).update_column(:basic_salary, nil)

      assert_no_difference [ "PayrollRun.count", "Payslip.count" ] do
        result = Payroll::OpenRun.call(company: @company, **@params)

        assert result.failure?
        assert_match(/Bob Worker/, result.message)
      end
    end
  end
end
