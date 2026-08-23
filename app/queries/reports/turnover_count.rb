module Reports
  # Raw departure count per department over a period — deliberately not
  # a rate (departures ÷ average headcount); that's an explicit
  # out-of-scope refinement per kos/projects/hris/features/basic-reporting/PLAN.md.
  class TurnoverCount
    def self.call(viewer:, start_date:, end_date:)
      Employee.where(company: viewer.company, last_working_day: start_date..end_date)
              .group(:department).order(:department).count
              .map { |department, departures| { department: department, departures: departures } }
    end
  end
end
