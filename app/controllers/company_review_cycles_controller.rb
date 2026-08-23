# Company Reviews — HR-Admin's filterable, company-wide, read-only
# roster of review cycles. "Start new cycle" is single-employee scope
# only (v1) — HR opens one cycle with its KPIs the same way a manager
# would from Team Reviews. See
# kos/decisions/ui/company-reviews-roster-filterable-grid-list.md.
class CompanyReviewCyclesController < ApplicationController
  def index
    authorize :company_review_cycle, :index?

    @employees = Employees::CompanyReviewRoster.call(
      viewer: current_employee, department: params[:department], status: params[:status], search: params[:q]
    )
    @departments = policy_scope(Employee).distinct.pluck(:department).compact.sort
  end

  def show
    @employee = policy_scope(Employee).find(params[:id])
    authorize @employee, :show?, policy_class: CompanyReviewCyclePolicy
    @review_cycles = @employee.review_cycles.includes(:kpi_entries).order(start_date: :desc)
  end

  def new
    authorize :company_review_cycle, :new?
    @employees = policy_scope(Employee).order(:last_name, :first_name)
  end

  def create
    authorize :company_review_cycle, :create?
    employee = policy_scope(Employee).find_by(id: review_cycle_params[:employee_id])

    ActiveRecord::Base.transaction do
      ReviewCycles::OpenCycle.call!(
        employee: employee,
        cycle_type: review_cycle_params[:cycle_type],
        start_date: review_cycle_params[:start_date],
        end_date: review_cycle_params[:end_date],
        kpi_entries_params: kpi_entries_params
      )
    end
    redirect_to company_review_cycles_path, notice: "Opened a review cycle for #{employee.full_name}."
  rescue Interactor::Failure => e
    redirect_to new_company_review_cycle_path, alert: e.context.message
  end

  private

  def review_cycle_params
    params.require(:review_cycle).permit(:employee_id, :cycle_type, :start_date, :end_date)
  end

  def kpi_entries_params
    params.fetch(:kpi_entries, []).map { |entry| entry.permit(:kpi_name, :target).to_h.symbolize_keys }
                                   .reject { |entry| entry[:kpi_name].blank? }
  end
end
