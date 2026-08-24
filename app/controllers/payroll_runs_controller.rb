class PayrollRunsController < ApplicationController
  def index
    authorize PayrollRun
    @open_run = policy_scope(PayrollRun).open.first
    @history = policy_scope(PayrollRun).finalized.order(period_start: :desc)
  end

  def new
    authorize PayrollRun
  end

  def create
    authorize PayrollRun

    result = Payroll::OpenRun.call(
      company: current_employee.company,
      period_start: params[:period_start],
      period_end: params[:period_end],
      pay_date: params[:pay_date]
    )

    if result.success?
      redirect_to payroll_run_path(result.payroll_run), notice: "Payroll run opened."
    else
      flash.now[:alert] = result.message
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @payroll_run = policy_scope(PayrollRun).includes(payslips: [ :employee, :payslip_line_items ]).find(params[:id])
    authorize @payroll_run
  end

  def finalize
    @payroll_run = policy_scope(PayrollRun).find(params[:id])
    authorize @payroll_run, :finalize?

    result = Payroll::FinalizeRun.call(payroll_run: @payroll_run, finalized_by: current_employee)

    if result.success?
      redirect_to payroll_run_path(@payroll_run), notice: "Payroll run finalized."
    else
      redirect_to payroll_run_path(@payroll_run), alert: result.message
    end
  end
end
