class RateTablesController < ApplicationController
  def index
    authorize RateTable
    RateTables::EnsureAllAgencies.call(company: current_employee.company)
    load_rate_tables
  end

  def update
    @rate_table = policy_scope(RateTable).find(params[:id])
    authorize @rate_table

    result = RateTables::UpdateRates.call(
      rate_table: @rate_table,
      effective_date: rate_table_params[:effective_date],
      brackets: rate_table_params[:brackets],
      fields: rate_table_params[:fields],
      updated_by: current_employee
    )

    if result.success?
      redirect_to rate_tables_path, notice: "#{@rate_table.display_name} rates updated."
    else
      flash.now[:alert] = result.message
      render_rate_tables_index_with_errors
    end
  end

  private

  # @rate_table already carries the failed attributes/errors — the
  # interactor mutated it in place. Splice it back into the freshly
  # loaded @rate_tables so its card's drawer forces open with the
  # validation errors visible, same reasoning as
  # Employees::LoansController#update keeping the unsaved record instead
  # of re-querying it away. See kos/decisions/ui/loan-ledger-flat-table-edit-drawer.md.
  def render_rate_tables_index_with_errors
    load_rate_tables
    @rate_tables = @rate_tables.map { |rate_table| rate_table.id == @rate_table.id ? @rate_table : rate_table }
    render :index, status: :unprocessable_entity
  end

  def load_rate_tables
    @rate_tables = policy_scope(RateTable).includes(:updated_by).order(:agency)
    @rate_tables_updated_within_year = @rate_tables.reject(&:stale?).size
    @oldest_rate_table = @rate_tables.min_by(&:updated_at)
  end

  def rate_table_params
    params.require(:rate_table).permit(
      :effective_date,
      brackets: [ :min, :max, :employee_share, :employer_share, :base_amount, :percent_over_excess ],
      fields: [ :employee_share_percent, :employer_share_percent, :income_floor, :income_ceiling, :compensation_cap ]
    )
  end
end
