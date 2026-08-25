module Reports
  class LeaveBalances
    def self.call(viewer:, year: Date.current.year, department: nil)
      scope = LeaveBalance.joins(:employee, :leave_type)
                          .where(employees: { company_id: viewer.company_id }, year: year)
      scope = scope.where(employees: { department: department }) if department.present?

      scope.order("employees.last_name, employees.first_name")
           .map do |balance|
             {
               employee: balance.employee.full_name,
               department: balance.employee.department,
               leave_type: balance.leave_type.name,
               entitled_days: balance.entitled_days,
               used_days: balance.used_days,
               remaining_days: balance.remaining_days
             }
           end
    end
  end
end
