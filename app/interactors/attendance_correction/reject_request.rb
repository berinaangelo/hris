module AttendanceCorrection
  class RejectRequest
    include Interactor

    def call
      correction_request = context.correction_request

      unless correction_request.pending?
        context.fail!(message: "This request has already been decided.")
        return
      end

      correction_request.update!(status: :rejected, reviewed_by: context.reviewer, reviewed_at: Time.current)
      AttendanceCorrection::NotifyDecision.call(correction_request: correction_request)
    end
  end
end
