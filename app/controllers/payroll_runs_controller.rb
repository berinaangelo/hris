require "csv"

class PayrollRunsController < ApplicationController
  def index
    authorize PayrollRun
    @open_run = policy_scope(PayrollRun).open.first
    @open_run_stats = run_stats(@open_run) if @open_run
    @pagy, @history = pagy(policy_scope(PayrollRun).finalized.order(period_start: :desc))
  end

  def new
    authorize PayrollRun
  end

  def create
    authorize PayrollRun

    interactor = params[:run_type] == "thirteenth_month" ? Payroll::OpenThirteenthMonthRun : Payroll::OpenRun
    result = interactor.call(
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
    @stats = run_stats(@payroll_run)

    respond_to do |format|
      format.html
      format.csv { send_data run_csv, filename: "payroll-run-#{@payroll_run.period_start}-#{@payroll_run.period_end}.csv" }
    end
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

  private

  # Employees / gross so far / loan deductions auto-added — the pinned
  # hero (index) and the stat strip (show) both need the same 3 tallies
  # for whichever run they're looking at.
  def run_stats(payroll_run)
    {
      employees: payroll_run.payslips.count,
      gross_so_far: payroll_run.payslips.sum(:gross_pay),
      loan_deductions: PayslipLineItem.where(payslip: payroll_run.payslips, line_type: :loan_repayment).count
    }
  end

  def run_csv
    CSV.generate do |csv|
      csv << [ "Employee", "Base Salary", "Adjustments", "Loan", "Statutory", "Net Pay", "Status" ]
      @payroll_run.payslips.each do |payslip|
        presenter = PayslipPresenter.new(payslip)
        csv << [
          payslip.employee.full_name, presenter.base_salary, presenter.adjustments_total,
          presenter.loan_deductions, presenter.statutory_deductions, payslip.net_pay, payslip.status
        ]
      end
    end
  end
end
