module Team
  # #index folded into Team::AttendanceRecordsController#index as part
  # of the Team Attendance merge — see
  # kos/decisions/ux-pages/time-attendance.html. Approve/reject stay
  # here and redirect back to that merged page.
  class AttendanceCorrectionRequestsController < ApplicationController
    def approve
      correction_request = AttendanceCorrectionRequest.find(params[:id])
      authorize correction_request, :approve?

      ActiveRecord::Base.transaction do
        AttendanceCorrection::ApproveRequest.call!(correction_request: correction_request, reviewer: current_employee)
      end
      redirect_to team_attendance_records_path,
                  notice: "Approved #{correction_request.employee.full_name}'s correction request."
    rescue Interactor::Failure => e
      redirect_to team_attendance_records_path, alert: e.context.message
    end

    def reject
      correction_request = AttendanceCorrectionRequest.find(params[:id])
      authorize correction_request, :reject?

      result = AttendanceCorrection::RejectRequest.call(correction_request: correction_request, reviewer: current_employee)

      if result.success?
        redirect_to team_attendance_records_path,
                    notice: "Rejected #{correction_request.employee.full_name}'s correction request."
      else
        redirect_to team_attendance_records_path, alert: result.message
      end
    end
  end
end
