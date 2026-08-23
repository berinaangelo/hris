module Leave
  class RejectRequest
    include Interactor

    def call
      leave_request = context.leave_request

      unless leave_request.pending?
        context.fail!(message: "This request has already been decided.")
        return
      end

      # Rejected requests never touched the balance (Leave::IncrementUsedBalance
      # only runs on approval), so there's nothing to undo here.
      leave_request.update!(status: :rejected, decided_at: Time.current, decision_note: context.decision_note)
      Leave::NotifyDecision.call(leave_request: leave_request)
    end
  end
end
