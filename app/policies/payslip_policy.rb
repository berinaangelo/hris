# Self-service for an employee's own payslips; admins can additionally
# reach any payslip in their company (Payslip Detail admin view,
# reached from Payroll Run Detail) — see
# kos/decisions/ui/payslip-detail-admin-breakdown-audit-rail.md.
class PayslipPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    record.employee_id == user.id || admin_in_company?
  end

  def void_and_reissue?
    admin_in_company?
  end

  def finalize?
    admin_in_company?
  end

  def edit_line_items?
    admin_in_company? && record.draft?
  end

  class Scope < Scope
    def resolve
      if user.admin?
        scope.joins(:employee).where(employees: { company_id: user.company_id })
      else
        scope.where(employee: user)
      end
    end
  end

  private

  def admin_in_company?
    user.admin? && record.employee.company_id == user.company_id
  end
end
