module Reports
  class NewHiresVsDepartures
    def self.call(viewer:, start_date:, end_date:)
      scope = Employee.where(company: viewer.company)
      hires = scope.where(start_date: start_date..end_date).group(:department).count
      departures = scope.where(last_working_day: start_date..end_date).group(:department).count

      (hires.keys | departures.keys).sort.map do |department|
        { department: department, new_hires: hires.fetch(department, 0), departures: departures.fetch(department, 0) }
      end
    end
  end
end
