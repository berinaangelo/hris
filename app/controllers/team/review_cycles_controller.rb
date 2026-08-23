# Team Reviews — a manager's editable workspace for direct reports'
# review cycles. See kos/decisions/ui/team-reviews-split-editable-detail.md.
module Team
  class ReviewCyclesController < ApplicationController
    def index
      authorize :team_review_cycle, :index?

      @direct_reports = Employees::TeamReviewRoster.call(manager: current_employee)
      @selected_employee = if params[:employee_id].present?
        @direct_reports.find { |employee| employee.id == params[:employee_id].to_i }
      else
        @direct_reports.first
      end
    end

    def create
      employee = Employees::TeamReviewRoster.call(manager: current_employee).find { |e| e.id == review_cycle_params[:employee_id].to_i }
      raise Pundit::NotAuthorizedError if employee.nil?

      authorize ReviewCycle.new(employee: employee), :create?

      ActiveRecord::Base.transaction do
        ReviewCycles::OpenCycle.call!(
          employee: employee,
          cycle_type: review_cycle_params[:cycle_type],
          start_date: review_cycle_params[:start_date],
          end_date: review_cycle_params[:end_date],
          kpi_entries_params: kpi_entries_params
        )
      end
      redirect_to team_review_cycles_path(employee_id: employee.id), notice: "Opened #{employee.full_name}'s review cycle."
    rescue Interactor::Failure => e
      redirect_to team_review_cycles_path(employee_id: employee&.id), alert: e.context.message
    end

    def attach_kpis
      review_cycle = ReviewCycle.find(params[:id])
      authorize review_cycle, :update?

      ActiveRecord::Base.transaction do
        ReviewCycles::AttachKpiEntries.call!(review_cycle: review_cycle, kpi_entries_params: kpi_entries_params)
      end
      redirect_to team_review_cycles_path(employee_id: review_cycle.employee_id), notice: "Added KPIs for #{review_cycle.employee.full_name}."
    rescue Interactor::Failure => e
      redirect_to team_review_cycles_path(employee_id: review_cycle.employee_id), alert: e.context.message
    end

    def save_draft
      review_cycle = ReviewCycle.find(params[:id])
      authorize review_cycle, :save_draft?

      result = ReviewCycles::SaveDraftScores.call(
        review_cycle: review_cycle, kpi_scores_params: kpi_scores_params, manager_comment: params[:manager_comment]
      )

      if result.success?
        redirect_to team_review_cycles_path(employee_id: review_cycle.employee_id), notice: "Draft saved."
      else
        redirect_to team_review_cycles_path(employee_id: review_cycle.employee_id), alert: result.message
      end
    end

    def publish
      review_cycle = ReviewCycle.find(params[:id])
      authorize review_cycle, :publish?

      ActiveRecord::Base.transaction do
        ReviewCycles::PublishCycle.call!(
          review_cycle: review_cycle, kpi_scores_params: kpi_scores_params,
          manager_comment: params[:manager_comment], outcome: params[:outcome]
        )
      end
      redirect_to team_review_cycles_path(employee_id: review_cycle.employee_id), notice: "Published #{review_cycle.employee.full_name}'s review."
    rescue Interactor::Failure => e
      redirect_to team_review_cycles_path(employee_id: review_cycle.employee_id), alert: e.context.message
    end

    private

    def review_cycle_params
      params.require(:review_cycle).permit(:employee_id, :cycle_type, :start_date, :end_date)
    end

    def kpi_entries_params
      params.fetch(:kpi_entries, []).map { |entry| entry.permit(:kpi_name, :target).to_h.symbolize_keys }
                                     .reject { |entry| entry[:kpi_name].blank? }
    end

    def kpi_scores_params
      params.fetch(:kpi_entries, {}).to_unsafe_h
    end
  end
end
