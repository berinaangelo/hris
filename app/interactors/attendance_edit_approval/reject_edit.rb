module AttendanceEditApproval
  # Reject is audit-only: it does not revert clock_in_at/clock_out_at
  # (the editor's values stay as-is) — a human fixes it via a separate
  # new edit if needed. See
  # kos/decisions/time-attendance-correction-request-and-manual-edit.md.
  class RejectEdit
    include Interactor

    def call
      attendance_record = context.attendance_record

      unless attendance_record.edit_approval_pending?
        context.fail!(message: "This edit has already been decided.")
        return
      end

      attendance_record.update!(edit_approval_status: :rejected, edit_approved_by: context.approver, edit_approved_at: Time.current)
      AttendanceEditApproval::NotifyEditDecision.call(attendance_record: attendance_record)
    end
  end
end
