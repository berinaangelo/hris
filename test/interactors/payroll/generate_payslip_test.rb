require "test_helper"

module Payroll
  class GeneratePayslipTest < ActiveSupport::TestCase
    test "generates base salary, loan, and statutory line items for a draft payslip" do
      employee = employees(:worker_bob) # basic_salary 40000.00, one active company loan at 1000.00/mo
      payroll_run = PayrollRun.create!(company: employee.company, period_start: Date.current.beginning_of_month,
                                        period_end: Date.current.end_of_month, pay_date: Date.current, run_type: :regular)

      result = Payroll::GeneratePayslip.call(employee: employee, payroll_run: payroll_run)

      assert result.success?
      payslip = result.payslip
      assert_equal "draft", payslip.status

      base_line = payslip.payslip_line_items.find_by(line_type: :base_salary)
      assert_equal 20000.00, base_line.amount # 40000 / 2, semi-monthly proration

      loan_line = payslip.payslip_line_items.find_by(line_type: :loan_repayment)
      assert_equal 1000.00, loan_line.amount
      assert_equal loans(:bob_company_loan), loan_line.loan

      assert_equal 202.50, payslip.payslip_line_items.find_by(line_type: :statutory_sss).amount
      assert_equal 500.0, payslip.payslip_line_items.find_by(line_type: :statutory_philhealth).amount
      assert_equal 100.00, payslip.payslip_line_items.find_by(line_type: :statutory_pagibig).amount
      assert_in_delta 1604.17, payslip.payslip_line_items.find_by(line_type: :statutory_bir).amount, 0.01

      assert_equal 20000.00, payslip.gross_pay
      assert_in_delta 16593.33, payslip.net_pay, 0.01
    end

    test "an employee with no active loans gets no loan_repayment line item" do
      employee = employees(:manager_jane)
      payroll_run = PayrollRun.create!(company: employee.company, period_start: Date.current.beginning_of_month,
                                        period_end: Date.current.end_of_month, pay_date: Date.current, run_type: :regular)

      result = Payroll::GeneratePayslip.call(employee: employee, payroll_run: payroll_run)

      assert result.success?
      assert_nil result.payslip.payslip_line_items.find_by(line_type: :loan_repayment)
    end
  end
end
