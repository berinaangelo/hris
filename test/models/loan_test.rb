require "test_helper"

class LoanTest < ActiveSupport::TestCase
  test "deletable? is true when never referenced by a payslip line item" do
    assert loans(:bob_company_loan).deletable?
  end

  test "deletable? is false once referenced by a payslip line item" do
    loan = loans(:bob_company_loan)
    payroll_run = PayrollRun.create!(company: companies(:acme), period_start: Date.current.beginning_of_month,
                                      period_end: Date.current.end_of_month, pay_date: Date.current, run_type: :regular)
    payslip = Payslip.create!(payroll_run: payroll_run, employee: loan.employee, status: :draft)
    payslip.payslip_line_items.create!(line_type: :loan_repayment, direction: :deduction, source: :loan, loan: loan, amount: loan.monthly_amortization)

    assert_not loan.deletable?
  end

  test "total_installments and progress_percent are computed, not persisted" do
    loan = loans(:bob_company_loan) # total_amount 12000, monthly_amortization 1000, remaining 12

    assert_equal 12, loan.total_installments
    assert_equal 0, loan.progress_percent

    loan.remaining_installments = 6
    assert_equal 50, loan.progress_percent
  end
end
