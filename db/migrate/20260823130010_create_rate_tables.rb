class CreateRateTables < ActiveRecord::Migration[8.1]
  def change
    create_table :rate_tables do |t|
      t.references :company, null: false, foreign_key: true

      t.integer :agency, null: false # sss, philhealth, pagibig, bir
      t.date :effective_date, null: false
      # Heterogeneous per agency — see kos/decisions/schema/payroll-v2-schema.md.
      # brackets: array of {min, max, employee_share, employer_share,
      #   base_amount, percent_over_excess} — SSS/BIR/Pag-IBIG.
      # fields: flat {key: value} — PhilHealth's rate %, Pag-IBIG's cap.
      t.json :brackets
      t.json :fields
      t.references :updated_by, null: true, foreign_key: { to_table: :employees }

      t.timestamps
    end

    add_index :rate_tables, [:company_id, :agency], unique: true
  end
end
