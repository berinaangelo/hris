module JobCandidates
  # "Hired" is the literal handoff into the existing employee system —
  # reuses Employees::Onboard as-is (same create-record + attach-
  # onboarding-checklist steps as any other new hire) rather than
  # duplicating it, then links the candidate record to the new
  # employee. Wrapped in a real DB transaction by the caller via
  # .call! — see kos/decisions/rails-db-transactions-locking-idempotency.md.
  class MarkHired
    include Interactor::Organizer

    organize Employees::Onboard, JobCandidates::LinkHiredEmployee
  end
end
