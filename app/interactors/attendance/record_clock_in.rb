module Attendance
  class RecordClockIn
    include Interactor

    def call
      employee = context.employee

      if employee.shift_template.nil?
        context.fail!(message: "You don't have a shift assigned yet — ask your admin to assign one before clocking in.")
        return
      end

      attendance_record = employee.attendance_records.find_or_initialize_by(date: employee.company.today)

      if attendance_record.clock_in_at.present?
        context.fail!(message: "You've already clocked in today.")
        return
      end

      attendance_record.shift_template ||= employee.shift_template
      attendance_record.clock_in_at = Time.current

      if attendance_record.save
        context.attendance_record = attendance_record
      else
        context.fail!(message: attendance_record.errors.full_messages.to_sentence)
      end
    end
  end
end
