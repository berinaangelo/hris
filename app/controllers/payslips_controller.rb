class PayslipsController < ApplicationController
  def index
    authorize Payslip
    @payslips = policy_scope(Payslip).finalized.includes(:payroll_run).order(created_at: :desc)
  end

  def show
    @payslip = policy_scope(Payslip).includes(:payroll_run, :payslip_line_items).find(params[:id])
    authorize @payslip
  end
end
