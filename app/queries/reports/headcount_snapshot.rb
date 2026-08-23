module Reports
  # Active employees as of a given date, by department. "Active as of"
  # is reconstructed from start_date/last_working_day rather than the
  # live Employee#status column, since status is current-state only
  # and this needs a point-in-time view.
  class HeadcountSnapshot
    def self.call(viewer:, as_of: Date.current)
      Employee.where(company: viewer.company)
              .where("start_date <= ?", as_of)
              .where("last_working_day IS NULL OR last_working_day > ?", as_of)
              .group(:department).order(:department).count
              .map { |department, headcount| { department: department, headcount: headcount } }
    end
  end
end
