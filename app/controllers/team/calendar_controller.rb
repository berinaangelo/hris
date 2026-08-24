# Team Calendar — read-only "who's out this week" for the viewing
# manager/admin's team. See kos/decisions/ui/team-calendar-week-agenda.md.
module Team
  class CalendarController < ApplicationController
    def show
      authorize :team_calendar, :show?

      @week_start = parse_week_start(params[:week_start]) || Date.current.beginning_of_week(:monday)
      @week_end = @week_start + 6.days
      @week_range_label = week_range_label(@week_start, @week_end)

      requests = LeaveRequests::OutForWeek.call(viewer: current_employee, week_start: @week_start)
      @days = (@week_start..@week_end).map { |date| [ date, requests.select { |request| request.start_date <= date && request.end_date >= date } ] }
    end

    private

    def week_range_label(week_start, week_end)
      start_format = week_start.year == week_end.year ? "%b %-d" : "%b %-d, %Y"
      end_format = week_start.month == week_end.month && week_start.year == week_end.year ? "%-d, %Y" : "%b %-d, %Y"
      "#{week_start.strftime(start_format)}–#{week_end.strftime(end_format)}"
    end

    def parse_week_start(value)
      value.presence&.to_date&.beginning_of_week(:monday)
    rescue ArgumentError, TypeError
      nil
    end
  end
end
