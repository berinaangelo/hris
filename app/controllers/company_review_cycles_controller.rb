# Company Reviews — HR-Admin's filterable, company-wide, read-only
# roster of review cycles. "Start new cycle" supports individual,
# department, and company-wide scope — department/company opens
# KPI-less "shell" cycles that each employee's manager later fills in
# from Team Reviews (see ReviewCycles::AttachKpiEntries), since KPI
# content is inherently role-specific and HR can't sensibly write it in
# bulk. See kos/decisions/ui/company-reviews-roster-filterable-grid-list.md.
class CompanyReviewCyclesController < ApplicationController
  def index
    authorize :company_review_cycle, :index?

    employees = Employees::CompanyReviewRoster.call(
      viewer: current_employee, department: params[:department], status: params[:status], search: params[:q]
    )
    @roster_stats = {
      total: employees.size,
      on_pip: employees.count { |employee| ReviewStatusPresenter.new(employee).on_pip? },
      needs_scoring: employees.count { |employee| ReviewStatusPresenter.new(employee).needs_scoring? }
    }
    @pagy, @employees = pagy(employees)
    @departments = policy_scope(Employee).distinct.pluck(:department).compact.sort
  end

  def show
    @employee = policy_scope(Employee).find(params[:id])
    authorize @employee, :show?, policy_class: CompanyReviewCyclePolicy
    @review_cycles = @employee.review_cycles.includes(:kpi_entries).order(start_date: :desc)
  end

  def new
    authorize :company_review_cycle, :new?
    @scope = scope_param
    @employees = policy_scope(Employee).order(:last_name, :first_name)
    @departments = policy_scope(Employee).distinct.pluck(:department).compact.sort
  end

  def create
    authorize :company_review_cycle, :create?
    scope = scope_param

    case scope
    when "individual"
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
    else
      employees = Employees::CompanyReviewRoster.call(
        viewer: current_employee, department: (review_cycle_params[:department] if scope == "department")
      )
      ActiveRecord::Base.transaction do
        employees.each do |employee|
          ReviewCycles::OpenCycle.call!(
            employee: employee,
            cycle_type: review_cycle_params[:cycle_type],
            start_date: review_cycle_params[:start_date],
            end_date: review_cycle_params[:end_date],
            kpi_entries_params: []
          )
        end
      end
      redirect_to company_review_cycles_path,
                  notice: "Opened #{employees.size} review cycle#{"s" unless employees.size == 1} — managers will add KPIs from Team Reviews."
    end
  rescue Interactor::Failure => e
    redirect_to new_company_review_cycle_path(scope: scope), alert: e.context.message
  end

  private

  def scope_param
    %w[individual department company].include?(params[:scope]) ? params[:scope] : "individual"
  end

  def review_cycle_params
    params.require(:review_cycle).permit(:employee_id, :department, :cycle_type, :start_date, :end_date)
  end

  def kpi_entries_params
    params.fetch(:kpi_entries, []).map { |entry| entry.permit(:kpi_name, :target).to_h.symbolize_keys }
                                   .reject { |entry| entry[:kpi_name].blank? }
  end
end
