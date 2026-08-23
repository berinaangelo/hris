class AttendanceCorrectionRequestsController < ApplicationController
  def index
    authorize AttendanceCorrectionRequest
    @correction_requests = policy_scope(AttendanceCorrectionRequest).order(created_at: :desc)
  end

  def new
    authorize AttendanceCorrectionRequest
  end

  def create
    authorize AttendanceCorrectionRequest

    result = AttendanceCorrection::SubmitRequest.call(
      employee: current_employee,
      date: correction_request_params[:date],
      requested_clock_in_at: correction_request_params[:requested_clock_in_at],
      requested_clock_out_at: correction_request_params[:requested_clock_out_at],
      reason: correction_request_params[:reason]
    )

    if result.success?
      redirect_to attendance_correction_requests_path, notice: "Correction requested."
    else
      flash.now[:alert] = result.message
      render :new, status: :unprocessable_entity
    end
  end

  private

  def correction_request_params
    params.require(:attendance_correction_request)
          .permit(:date, :requested_clock_in_at, :requested_clock_out_at, :reason)
  end
end
