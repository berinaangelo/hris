module AttendanceCorrection
  class SubmitRequest
    include Interactor

    def call
      employee = context.employee
      date = context.date

      if AttendanceCorrectionRequest.pending_for(employee.id, date).exists?
        context.fail!(message: "You already have a pending correction request for that date.")
        return
      end

      correction_request = AttendanceCorrectionRequest.new(
        employee: employee,
        attendance_record: employee.attendance_records.find_by(date: date),
        date: date,
        requested_clock_in_at: context.requested_clock_in_at,
        requested_clock_out_at: context.requested_clock_out_at,
        reason: context.reason
      )

      if correction_request.save
        context.correction_request = correction_request
        AttendanceCorrectionRequestSubmittedNotifierJob.perform_later(correction_request)
      else
        context.fail!(message: correction_request.errors.full_messages.to_sentence)
      end
    end
  end
end
