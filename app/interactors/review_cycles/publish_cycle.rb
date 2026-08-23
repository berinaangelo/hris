module ReviewCycles
  # Wrapped in a real DB transaction by the caller via .call! — see
  # kos/decisions/rails-db-transactions-locking-idempotency.md.
  class PublishCycle
    include Interactor::Organizer

    organize ReviewCycles::SaveDraftScores, ReviewCycles::MarkFullyScored, ReviewCycles::MarkPublished,
             ReviewCycles::NotifyCyclePublished
  end
end
