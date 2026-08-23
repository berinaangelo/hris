module AttendanceEditApproval
  class MarkEditApproved
    include Interactor

    def call
      attendance_record = context.attendance_record

      unless attendance_record.edit_approval_pending?
        context.fail!(message: "This edit has already been decided.")
        return
      end

      attendance_record.update!(edit_approval_status: :approved, edit_approved_by: context.approver, edit_approved_at: Time.current)
    end

    def rollback
      context.attendance_record.update!(edit_approval_status: :pending, edit_approved_by: nil, edit_approved_at: nil)
    end
  end
end
