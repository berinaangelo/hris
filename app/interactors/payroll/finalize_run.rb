module Payroll
  # Pessimistic locking + idempotency — a double-click can't double-
  # process, per kos/decisions/rails-db-transactions-locking-idempotency.md
  # and app/models/payroll_run.rb's own comment. Deliberately one plain
  # Interactor, not an Organizer — the atomicity needs to live inside a
  # single with_lock block, not spread across separate step objects.
  class FinalizeRun
    include Interactor

    def call
      payroll_run = context.payroll_run

      payroll_run.with_lock do
        next if payroll_run.finalized? # idempotent no-op on a second click

        finalize_payslips(payroll_run)
        decrement_loans(payroll_run)
        payroll_run.update!(status: :finalized, finalized_at: Time.current, finalized_by: context.finalized_by)
      end
    end

    private

    def finalize_payslips(payroll_run)
      payroll_run.payslips.draft.each do |payslip|
        payslip.update!(status: :finalized, generated_at: Time.current, generated_by: context.finalized_by)
      end
    end

    def decrement_loans(payroll_run)
      loan_line_items = PayslipLineItem.where(payslip: payroll_run.payslips, source: :loan)

      loan_line_items.each do |line_item|
        next unless line_item.loan # belt-and-suspenders: Loan#deletable? already blocks destroying a referenced loan

        line_item.loan.with_lock do
          loan = line_item.loan
          loan.decrement!(:remaining_installments)
          loan.update!(status: :paid_off) if loan.remaining_installments <= 0
        end
      end
    end
  end
end
