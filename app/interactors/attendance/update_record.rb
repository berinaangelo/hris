module Attendance
  # Direct manual edit by an admin/manager — distinct from
  # AttendanceCorrection::ApplyToAttendanceRecord, which applies an
  # employee-submitted correction request (and is its own sign-off step,
  # unaffected by this). Takes effect immediately regardless of
  # edit_approval_status — that column is oversight-only, see
  # kos/decisions/time-attendance-correction-request-and-manual-edit.md.
  class UpdateRecord
    include Interactor

    def call
      attendance_record = context.attendance_record
      editor = context.editor

      attendance_record.clock_in_at = context.clock_in_at if context.clock_in_at.present?
      attendance_record.clock_out_at = context.clock_out_at if context.clock_out_at.present?
      # Status is only resolvable once both times are on the record — an
      # in-progress shift (no clock-out yet) stays whatever it already
      # was, same as the pre-clock-out window in RecordClockOut/RecordClockIn.
      if attendance_record.clock_in_at.present? && attendance_record.clock_out_at.present?
        attendance_record.status = Attendance::ResolveStatus.call(attendance_record)
      end
      attendance_record.manually_edited = true
      attendance_record.edited_by = editor
      attendance_record.edited_at = Time.current
      attendance_record.edit_approval_status = edit_approval_status_for(editor)
      attendance_record.edit_approved_by = nil
      attendance_record.edit_approved_at = nil

      if attendance_record.save
        context.attendance_record = attendance_record
      else
        context.fail!(message: attendance_record.errors.full_messages.to_sentence)
      end
    end

    private

    # Only a manager-made edit is gated, and only when the company has
    # turned on approver sign-off. An admin edit is never gated — admin
    # is the top authority here, so there's no one above to sign off and
    # no self-approval edge case. See
    # kos/decisions/time-attendance-correction-request-and-manual-edit.md.
    def edit_approval_status_for(editor)
      return :not_required unless editor.manager?

      editor.company.attendance_approvers_enabled? ? :pending : :not_required
    end
  end
end
