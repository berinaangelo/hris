module Payroll
  # Shared by Payroll::OpenRun and Payroll::OpenThirteenthMonthRun —
  # still-owed pay includes employees mid-offboarding, not just fully
  # active ones.
  class PayableEmployees
    def self.call(company)
      company.employees.where.not(status: :offboarded)
    end
  end
end
