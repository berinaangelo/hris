require "test_helper"

module Employees
  class LoansControllerTest < ActionDispatch::IntegrationTest
    test "admin can add a loan for an employee" do
      sign_in employees(:admin_amy)
      employee = employees(:worker_carol)

      assert_difference "Loan.count", 1 do
        post employee_loans_path(employee), params: {
          loan: { loan_type: "sss_salary_loan", total_amount: 24000, monthly_amortization: 1000, remaining_installments: 24 }
        }
      end

      assert_redirected_to employee_path(employee)
    end

    test "admin can update a loan's remaining installments" do
      sign_in employees(:admin_amy)
      loan = loans(:bob_company_loan)

      patch employee_loan_path(loan.employee, loan), params: {
        loan: { loan_type: loan.loan_type, total_amount: loan.total_amount, monthly_amortization: loan.monthly_amortization, remaining_installments: 10 }
      }

      assert_redirected_to employee_path(loan.employee)
      assert_equal 10, loan.reload.remaining_installments
    end

    test "admin can remove a loan never referenced by a payslip" do
      sign_in employees(:admin_amy)
      loan = loans(:bob_company_loan)

      assert_difference "Loan.count", -1 do
        delete employee_loan_path(loan.employee, loan)
      end

      assert_redirected_to employee_path(loan.employee)
    end

    test "admin cannot remove a loan already referenced by a payslip" do
      sign_in employees(:admin_amy)
      loan = loans(:bob_company_loan)
      payroll_run = PayrollRun.create!(company: companies(:acme), period_start: Date.current.beginning_of_month,
                                        period_end: Date.current.end_of_month, pay_date: Date.current, run_type: :regular)
      payslip = Payslip.create!(payroll_run: payroll_run, employee: loan.employee, status: :draft)
      payslip.payslip_line_items.create!(line_type: :loan_repayment, direction: :deduction, source: :loan, loan: loan, amount: loan.monthly_amortization)

      assert_no_difference "Loan.count" do
        delete employee_loan_path(loan.employee, loan)
      end

      assert_redirected_to employee_path(loan.employee)
    end

    test "manager is forbidden" do
      sign_in employees(:manager_jane)
      employee = employees(:worker_carol)

      post employee_loans_path(employee), params: {
        loan: { loan_type: "sss_salary_loan", total_amount: 24000, monthly_amortization: 1000, remaining_installments: 24 }
      }

      assert_redirected_to root_path
    end

    test "admin cannot manage another company's employee loans" do
      sign_in employees(:admin_gary)
      loan = loans(:bob_company_loan)

      patch employee_loan_path(loan.employee, loan), params: {
        loan: { loan_type: loan.loan_type, total_amount: loan.total_amount, monthly_amortization: loan.monthly_amortization, remaining_installments: 1 }
      }

      assert_response :not_found
      assert_equal 12, loan.reload.remaining_installments
    end

    test "validation failure re-renders with typed values preserved" do
      sign_in employees(:admin_amy)
      employee = employees(:worker_carol)

      assert_no_difference "Loan.count" do
        post employee_loans_path(employee), params: {
          loan: { loan_type: "sss_salary_loan", total_amount: -1, monthly_amortization: 1000, remaining_installments: 24 }
        }
      end

      assert_response :unprocessable_entity
    end

    private

    def sign_in(employee)
      post session_path, params: { work_email: employee.work_email, password: "password" }
    end
  end
end
