module AttendanceEditApproval
  # Wrapped in a real DB transaction by the caller via .call! — see
  # kos/decisions/rails-db-transactions-locking-idempotency.md (plain
  # .call swallows failure into context.success?/failure? without
  # raising, so it won't trigger a transaction rollback on its own).
  class ApproveEdit
    include Interactor::Organizer

    organize AttendanceEditApproval::MarkEditApproved, AttendanceEditApproval::NotifyEditDecision
  end
end
