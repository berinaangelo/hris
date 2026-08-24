module Payroll
  # The only correction path for an already-finalized payslip — a
  # finalized cutoff's line items are locked
  # (kos/decisions/rails-db-transactions-locking-idempotency.md), so
  # fixing a mistake means voiding the current version (with a reason)
  # and starting a new editable one, not editing in place. Deliberately
  # one plain Interactor with its own with_lock, same shape as
  # FinalizeRun/FinalizePayslip.
  class VoidAndReissuePayslip
    include Interactor

    def call
      old_payslip = context.payslip

      old_payslip.with_lock do
        unless old_payslip.finalized?
          context.fail!(message: "Only a finalized payslip can be voided and reissued.")
        end

        old_payslip.update!(status: :voided, void_reason: context.void_reason)
        new_payslip = build_reissue(old_payslip)
        copy_line_items(old_payslip, new_payslip)
        Payroll::RecomputePayslipTotals.call!(payslip: new_payslip)

        context.new_payslip = new_payslip
      end
    end

    private

    def build_reissue(old_payslip)
      old_payslip.employee.payslips.create!(
        payroll_run: old_payslip.payroll_run, status: :draft, previous_version_id: old_payslip.id
      )
    end

    def copy_line_items(old_payslip, new_payslip)
      old_payslip.payslip_line_items.each do |line_item|
        new_payslip.payslip_line_items.create!(
          line_type: line_item.line_type, direction: line_item.direction, source: line_item.source,
          loan_id: line_item.loan_id, description: line_item.description, amount: line_item.amount
        )
      end
    end
  end
end
