module Reports
  class LeaveTakenSummary
    def self.call(viewer:, start_date:, end_date:)
      LeaveRequest.joins(:employee).approved
                  .where(employees: { company_id: viewer.company_id })
                  .where("leave_requests.start_date <= ? AND leave_requests.end_date >= ?", end_date, start_date)
                  .group("employees.department").order("employees.department")
                  .sum(:days_requested)
                  .map { |department, days_taken| { department: department, days_taken: days_taken } }
    end
  end
end
