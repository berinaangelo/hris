class CreatePayrollRuns < ActiveRecord::Migration[8.1]
  def change
    create_table :payroll_runs do |t|
      t.references :company, null: false, foreign_key: true

      t.date :period_start, null: false
      t.date :period_end, null: false
      t.date :pay_date, null: false
      t.integer :run_type, null: false, default: 0 # regular, thirteenth_month
      t.integer :status, null: false, default: 0 # open, finalized
      t.datetime :finalized_at
      t.references :finalized_by, null: true, foreign_key: { to_table: :employees }

      t.timestamps
    end

    # Only one open run per company at a time is an app-level rule
    # (Payroll::OpenRun), not a DB constraint — MySQL has no partial/
    # filtered unique index. See kos/decisions/schema/payroll-v2-schema.md.
    add_index :payroll_runs, [:company_id, :status]
  end
end
