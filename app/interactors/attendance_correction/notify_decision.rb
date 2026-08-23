module AttendanceCorrection
  # Shared by AttendanceCorrection::ApproveRequest and
  # AttendanceCorrection::RejectRequest so the enqueue call isn't
  # duplicated across both decision paths.
  class NotifyDecision
    include Interactor

    def call
      AttendanceCorrectionDecisionNotifierJob.perform_later(context.correction_request)
    end
  end
end
