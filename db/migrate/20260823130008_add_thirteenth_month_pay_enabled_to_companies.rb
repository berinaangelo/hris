class AddThirteenthMonthPayEnabledToCompanies < ActiveRecord::Migration[8.1]
  def change
    # Per kos/decisions/thirteenth-month-pay-mandatory-in-ph.md — the
    # toggle still needs to exist for companies outside PD 851's scope
    # (non-PH deployment, all-managerial workforce), default true since
    # it's mandatory for rank-and-file PH employees.
    add_column :companies, :thirteenth_month_pay_enabled, :boolean, null: false, default: true
  end
end
