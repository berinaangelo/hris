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
      attendance_record.status = Attendance::ResolveStatus.call(attendance_record)

      if attendance_record.save
        context.attendance_record = attendance_record
      else
        context.fail!(message: attendance_record.errors.full_messages.to_sentence)
      end
    end
  end
end
