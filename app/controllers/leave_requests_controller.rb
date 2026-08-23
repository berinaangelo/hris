class LeaveRequestsController < ApplicationController
  def index
    authorize LeaveRequest
    @leave_requests = policy_scope(LeaveRequest).includes(:leave_type).order(created_at: :desc)
    @leave_types = LeaveType.where(company: current_employee.company)
  end

  def new
    authorize LeaveRequest
    @leave_types = LeaveType.where(company: current_employee.company)
  end

  def create
    authorize LeaveRequest

    result = Leave::SubmitRequest.call(
      employee: current_employee,
      leave_type_id: leave_request_params[:leave_type_id],
      start_date: leave_request_params[:start_date],
      end_date: leave_request_params[:end_date],
      days_requested: leave_request_params[:days_requested],
      reason: leave_request_params[:reason]
    )

    if result.success?
      redirect_to leave_requests_path, notice: "Time off requested."
    else
      flash.now[:alert] = result.message
      @leave_types = LeaveType.where(company: current_employee.company)
      render :new, status: :unprocessable_entity
    end
  end

  private

  def leave_request_params
    params.require(:leave_request).permit(:leave_type_id, :start_date, :end_date, :days_requested, :reason)
  end
end
