module AttendanceEditApproval
  # Shared by AttendanceEditApproval::ApproveEdit and
  # AttendanceEditApproval::RejectEdit so the enqueue call isn't
  # duplicated across both decision paths.
  class NotifyEditDecision
    include Interactor

    def call
      AttendanceEditDecisionNotifierJob.perform_later(context.attendance_record)
    end
  end
end
