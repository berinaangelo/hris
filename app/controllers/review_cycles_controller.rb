# My Reviews — an employee's own read-only review history. See
# kos/decisions/ui/my-reviews-split-master-detail.md.
class ReviewCyclesController < ApplicationController
  def index
    authorize ReviewCycle
    @review_cycles = policy_scope(ReviewCycle).includes(:kpi_entries).order(start_date: :desc)
    @selected_cycle = params[:cycle_id].present? ? @review_cycles.find(params[:cycle_id]) : @review_cycles.first
  end
end
