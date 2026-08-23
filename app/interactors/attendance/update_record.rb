module Attendance
  # Direct manual edit by an admin/manager — distinct from
  # AttendanceCorrection::ApplyToAttendanceRecord, which applies an
  # employee-submitted correction request. Takes effect immediately, no
  # approver sign-off step (edit_approval_status stays not_required) —
  # attendance_approvers_enabled is a later pass, see
  # kos/decisions/time-attendance-correction-request-and-manual-edit.md.
  class UpdateRecord
    include Interactor

    def call
      attendance_record = context.attendance_record

      attendance_record.clock_in_at = context.clock_in_at if context.clock_in_at.present?
      attendance_record.clock_out_at = context.clock_out_at if context.clock_out_at.present?
      # Status is only resolvable once both times are on the record — an
      # in-progress shift (no clock-out yet) stays whatever it already
      # was, same as the pre-clock-out window in RecordClockOut/RecordClockIn.
      if attendance_record.clock_in_at.present? && attendance_record.clock_out_at.present?
        attendance_record.status = Attendance::ResolveStatus.call(attendance_record)
      end
      attendance_record.manually_edited = true
      attendance_record.edited_by = context.editor
      attendance_record.edited_at = Time.current

      if attendance_record.save
        context.attendance_record = attendance_record
      else
        context.fail!(message: attendance_record.errors.full_messages.to_sentence)
      end
    end
  end
end
