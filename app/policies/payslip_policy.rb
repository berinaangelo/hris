# Self-service only this pass — admins already see payslip data via
# the Payroll Run show page, not through this controller.
class PayslipPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    record.employee_id == user.id
  end

  class Scope < Scope
    def resolve
      scope.where(employee: user)
    end
  end
end
