module Attendance
  # Pure computation, no DB/context — extracted from
  # Attendance::RecordClockOut so Attendance::UpdateRecord can reuse the
  # exact same late/undertime resolution instead of duplicating it.
  class ResolveStatus
    # Late takes priority over undertime when both apply (e.g. clocked in
    # late AND clocked out early) — arriving late is the more actionable
    # signal for whoever reviews the day. Exact time-of-day comparison,
    # no grace period — a comparison, not a rules engine, per
    # kos/projects/hris/features/time-attendance/PLAN.md.
    def self.call(attendance_record)
      timezone = attendance_record.employee.company.timezone
      shift = attendance_record.shift_template

      clock_in_seconds = attendance_record.clock_in_at.in_time_zone(timezone).seconds_since_midnight
      clock_out_seconds = attendance_record.clock_out_at.in_time_zone(timezone).seconds_since_midnight

      return :late if clock_in_seconds > shift.start_time.seconds_since_midnight
      return :undertime if clock_out_seconds < shift.end_time.seconds_since_midnight

      :on_time
    end
  end
end
