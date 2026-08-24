class LeaveRequestsController < ApplicationController
  include LoadsPrimaryLeaveBalance

  def index
    authorize LeaveRequest
    load_form_and_history_data
    @leave_request ||= LeaveRequest.new
  end

  def new
    authorize LeaveRequest
    load_form_and_history_data
    @leave_request = LeaveRequest.new
    @open_request_modal = true
    render :index
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
      load_form_and_history_data
      @leave_request = result.leave_request || LeaveRequest.new(leave_request_params)
      @open_request_modal = true
      render :index, status: :unprocessable_entity
    end
  end

  private

  def load_form_and_history_data
    @leave_requests = policy_scope(LeaveRequest).includes(:leave_type).order(created_at: :desc)
    @leave_types = LeaveType.where(company: current_employee.company)
    @leave_balance = current_leave_balance
  end

  def leave_request_params
    params.require(:leave_request).permit(:leave_type_id, :start_date, :end_date, :days_requested, :reason)
  end
end
