class AttendanceCorrectionRequestsController < ApplicationController
  def index
    authorize AttendanceCorrectionRequest
    load_history
    @correction_request ||= AttendanceCorrectionRequest.new
  end

  def new
    authorize AttendanceCorrectionRequest
    load_history
    @correction_request = AttendanceCorrectionRequest.new
    @open_request_modal = true
    render :index
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
      load_history
      @correction_request = result.correction_request || AttendanceCorrectionRequest.new(correction_request_params)
      @open_request_modal = true
      render :index, status: :unprocessable_entity
    end
  end

  private

  def load_history
    @correction_requests = policy_scope(AttendanceCorrectionRequest).order(created_at: :desc)
  end

  def correction_request_params
    params.require(:attendance_correction_request)
          .permit(:date, :requested_clock_in_at, :requested_clock_out_at, :reason)
  end
end
