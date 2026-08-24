module Payroll
  # Finalizes a single payslip — distinct from the run-wide FinalizeRun,
  # which finalizes every draft payslip in a run at once. This is for
  # the one case a payslip needs finalizing on its own: a Void &
  # Reissue correction created after the run itself was already
  # finalized. Same pessimistic-locking + idempotency shape as
  # FinalizeRun (kos/decisions/rails-db-transactions-locking-idempotency.md).
  #
  # Deliberately does NOT touch loan installments — decrementing is a
  # one-time event tied to the original run's FinalizeRun; a reissue is
  # a correction within that same already-processed run, so
  # re-decrementing here would double-count.
  class FinalizePayslip
    include Interactor

    def call
      payslip = context.payslip

      payslip.with_lock do
        next if payslip.finalized? # idempotent no-op on a second click

        unless payslip.draft?
          context.fail!(message: "Only a draft payslip can be finalized.")
        end

        payslip.update!(status: :finalized, generated_at: Time.current, generated_by: context.finalized_by)
      end
    end
  end
end
