module Leave
  class IncrementUsedBalance
    include Interactor

    def call
      leave_request = context.leave_request
      balance = LeaveBalance.find_or_create_by!(
        employee: leave_request.employee,
        leave_type: leave_request.leave_type,
        year: leave_request.start_date.year
      )

      balance.update!(used_days: balance.used_days + leave_request.days_requested)
    rescue ActiveRecord::StaleObjectError
      # Per kos/decisions/rails-db-transactions-locking-idempotency.md —
      # surface the conflict rather than silently clobber; the caller
      # re-approves, which recomputes from the now-current balance.
      context.fail!(message: "This employee's balance was just changed elsewhere — please retry.")
    end

    def rollback
      leave_request = context.leave_request
      balance = LeaveBalance.find_by(
        employee: leave_request.employee,
        leave_type: leave_request.leave_type,
        year: leave_request.start_date.year
      )
      balance&.update!(used_days: balance.used_days - leave_request.days_requested)
    end
  end
end
