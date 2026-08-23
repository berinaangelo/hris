module Team
  class AttendanceCorrectionRequestsController < ApplicationController
    def index
      authorize :team_approval, :index?

      @pending = AttendanceCorrectionRequests::PendingForApprover.call(current_employee)
      @decided = AttendanceCorrectionRequest.where(reviewed_by: current_employee).where.not(status: :pending)
                                             .includes(:employee).order(reviewed_at: :desc).limit(10)
    end

    def approve
      correction_request = AttendanceCorrectionRequest.find(params[:id])
      authorize correction_request, :approve?

      ActiveRecord::Base.transaction do
        AttendanceCorrection::ApproveRequest.call!(correction_request: correction_request, reviewer: current_employee)
      end
      redirect_to team_attendance_correction_requests_path,
                  notice: "Approved #{correction_request.employee.full_name}'s correction request."
    rescue Interactor::Failure => e
      redirect_to team_attendance_correction_requests_path, alert: e.context.message
    end

    def reject
      correction_request = AttendanceCorrectionRequest.find(params[:id])
      authorize correction_request, :reject?

      result = AttendanceCorrection::RejectRequest.call(correction_request: correction_request, reviewer: current_employee)

      if result.success?
        redirect_to team_attendance_correction_requests_path,
                    notice: "Rejected #{correction_request.employee.full_name}'s correction request."
      else
        redirect_to team_attendance_correction_requests_path, alert: result.message
      end
    end
  end
end
