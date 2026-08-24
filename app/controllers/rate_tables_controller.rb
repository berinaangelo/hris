class RateTablesController < ApplicationController
  def index
    authorize RateTable
    RateTables::EnsureAllAgencies.call(company: current_employee.company)
    @rate_tables = policy_scope(RateTable).order(:agency)
  end

  def edit
    @rate_table = policy_scope(RateTable).find(params[:id])
    authorize @rate_table
  end

  def update
    @rate_table = policy_scope(RateTable).find(params[:id])
    authorize @rate_table

    result = RateTables::UpdateRates.call(
      rate_table: @rate_table,
      effective_date: params[:rate_table][:effective_date],
      brackets_json: params[:rate_table][:brackets_json],
      fields_json: params[:rate_table][:fields_json],
      updated_by: current_employee
    )

    if result.success?
      redirect_to rate_tables_path, notice: "#{@rate_table.agency.humanize} rates updated."
    else
      flash.now[:alert] = result.message
      render :edit, status: :unprocessable_entity
    end
  end
end
