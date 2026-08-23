class CreatePayslips < ActiveRecord::Migration[8.1]
  def change
    create_table :payslips do |t|
      t.references :payroll_run, null: false, foreign_key: true
      t.references :employee, null: false, foreign_key: true
      # Void & Reissue version chain — the row pointed to gets
      # status: voided when this one is created. See
      # kos/decisions/schema/payroll-v2-schema.md.
      t.references :previous_version, null: true, foreign_key: { to_table: :payslips }

      t.integer :status, null: false, default: 0 # draft, finalized, voided
      t.decimal :gross_pay, precision: 10, scale: 2, null: false, default: 0
      t.decimal :total_deductions, precision: 10, scale: 2, null: false, default: 0
      t.decimal :net_pay, precision: 10, scale: 2, null: false, default: 0
      t.text :void_reason

      t.datetime :generated_at
      t.references :generated_by, null: true, foreign_key: { to_table: :employees }
      t.datetime :emailed_at
      t.datetime :viewed_at

      t.timestamps
    end

    add_index :payslips, [:payroll_run_id, :employee_id]
    add_index :payslips, :status
  end
end
