class PayrollSettingsController < ApplicationController
  def show
    authorize :payroll_settings, :show?
    @company = current_employee.company
    @employees_covered = @company.employees.active.count
    @rate_tables_stale_count = @company.rate_tables.select(&:stale?).size
    @rate_tables_total_count = @company.rate_tables.size
  end

  def update
    authorize :payroll_settings, :update?

    if current_employee.company.update(payroll_settings_params)
      redirect_to payroll_settings_path, notice: "Payroll settings saved."
    else
      redirect_to payroll_settings_path, alert: current_employee.company.errors.full_messages.to_sentence
    end
  end

  private

  def payroll_settings_params
    params.require(:company).permit(:thirteenth_month_pay_enabled)
  end
end
