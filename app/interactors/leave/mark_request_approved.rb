module Leave
  class MarkRequestApproved
    include Interactor

    def call
      leave_request = context.leave_request

      unless leave_request.pending?
        context.fail!(message: "This request has already been decided.")
        return
      end

      leave_request.update!(status: :approved, decided_at: Time.current)
    end

    def rollback
      context.leave_request.update!(status: :pending, decided_at: nil)
    end
  end
end
