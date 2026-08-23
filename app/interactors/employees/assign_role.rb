module Employees
  class AssignRole
    include Interactor

    def call
      employee = context.employee
      role = context.role

      if employee.admin? && role.to_s != "admin" && employee.company.employees.admin.count == 1
        context.fail!(message: "Company needs at least one Admin — assign another employee as Admin first.")
        return
      end

      employee.update!(role: role)
    end
  end
end
