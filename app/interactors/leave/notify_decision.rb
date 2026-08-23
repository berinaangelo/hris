module Leave
  # Shared by Leave::ApproveRequest and Leave::RejectRequest so the
  # enqueue call isn't duplicated across both decision paths — see
  # kos/decisions/rails-activejob-solid-queue-for-background-work.md.
  class NotifyDecision
    include Interactor

    def call
      LeaveDecisionNotifierJob.perform_later(context.leave_request)
    end
  end
end
