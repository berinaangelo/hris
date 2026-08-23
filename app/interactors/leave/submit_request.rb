module Leave
  class SubmitRequest
    include Interactor

    def call
      employee = context.employee
      start_date = context.start_date
      end_date = context.end_date

      if LeaveRequest.overlapping(employee.id, start_date, end_date).exists?
        context.fail!(message: "This overlaps a request you've already submitted.")
        return
      end

      leave_request = LeaveRequest.new(
        employee: employee,
        leave_type_id: context.leave_type_id,
        approver: employee.manager,
        start_date: start_date,
        end_date: end_date,
        days_requested: context.days_requested,
        reason: context.reason
      )

      if leave_request.save
        context.leave_request = leave_request
        LeaveRequestSubmittedNotifierJob.perform_later(leave_request)
      else
        context.fail!(message: leave_request.errors.full_messages.to_sentence)
      end
    end
  end
end
