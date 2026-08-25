module Reports
  # Figures are already computed once and stored on Payslip (a
  # finalized cutoff's figures are locked, per
  # kos/decisions/schema/payroll-v2-schema.md) — this report just reads
  # them, no computation.
  class PayrollRegister
    def self.call(viewer:, payroll_run_id:, department: nil)
      payroll_run = PayrollRun.find_by(id: payroll_run_id, company: viewer.company)
      return [] unless payroll_run

      scope = payroll_run.payslips.joins(:employee).includes(:employee)
      scope = scope.where(employees: { department: department }) if department.present?

      scope.order("employees.last_name, employees.first_name")
           .map do |payslip|
             {
               employee: payslip.employee.full_name,
               department: payslip.employee.department,
               gross_pay: payslip.gross_pay,
               total_deductions: payslip.total_deductions,
               net_pay: payslip.net_pay
             }
           end
    end
  end
end
