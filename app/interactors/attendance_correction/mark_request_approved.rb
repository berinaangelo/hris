module AttendanceCorrection
  class MarkRequestApproved
    include Interactor

    def call
      correction_request = context.correction_request

      unless correction_request.pending?
        context.fail!(message: "This request has already been decided.")
        return
      end

      correction_request.update!(status: :approved, reviewed_by: context.reviewer, reviewed_at: Time.current)
    end

    def rollback
      context.correction_request.update!(status: :pending, reviewed_by: nil, reviewed_at: nil)
    end
  end
end
