module AttendanceCorrection
  # Approving a correction request already IS the edit-approval step —
  # per kos/decisions/time-attendance-correction-request-and-manual-edit.md
  # there's no separate edit_approval_status flag to flip later, it's set
  # to approved right here.
  class ApplyToAttendanceRecord
    include Interactor

    def call
      correction_request = context.correction_request
      employee = correction_request.employee

      attendance_record = correction_request.attendance_record ||
                           employee.attendance_records.find_or_initialize_by(date: correction_request.date)
      newly_created = attendance_record.new_record?

      if newly_created && employee.shift_template.nil?
        context.fail!(message: "#{employee.full_name} has no shift template assigned, so a new attendance record can't be created.")
        return
      end

      attendance_record.shift_template ||= employee.shift_template
      attendance_record.clock_in_at = correction_request.requested_clock_in_at if correction_request.requested_clock_in_at.present?
      attendance_record.clock_out_at = correction_request.requested_clock_out_at if correction_request.requested_clock_out_at.present?
      attendance_record.manually_edited = true
      attendance_record.edited_by = context.reviewer
      attendance_record.edited_at = Time.current
      attendance_record.edit_approval_status = :approved

      if attendance_record.save
        context.attendance_record = attendance_record
        correction_request.update!(attendance_record: attendance_record) if newly_created
      else
        context.fail!(message: attendance_record.errors.full_messages.to_sentence)
      end
    end
  end
end
