module Attendance
  class RecordClockOut
    include Interactor

    def call
      employee = context.employee
      attendance_record = employee.attendance_records.find_by(date: employee.company.today)

      if attendance_record&.clock_in_at.blank?
        context.fail!(message: "Clock in first.")
        return
      end

      if attendance_record.clock_out_at.present?
        context.fail!(message: "You've already clocked out today.")
        return
      end

      attendance_record.clock_out_at = Time.current
      attendance_record.status = resolved_status(attendance_record)

      if attendance_record.save
        context.attendance_record = attendance_record
      else
        context.fail!(message: attendance_record.errors.full_messages.to_sentence)
      end
    end

    private

    # Late takes priority over undertime when both apply (e.g. clocked in
    # late AND clocked out early) — arriving late is the more actionable
    # signal for whoever reviews the day. Exact time-of-day comparison,
    # no grace period — a comparison, not a rules engine, per
    # kos/projects/hris/features/time-attendance/PLAN.md.
    def resolved_status(attendance_record)
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
