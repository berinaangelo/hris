class CreateLoans < ActiveRecord::Migration[8.1]
  def change
    create_table :loans do |t|
      t.references :employee, null: false, foreign_key: true

      t.integer :loan_type, null: false # sss_salary_loan, pagibig_mpl, pagibig_calamity, company_loan
      t.decimal :total_amount, precision: 12, scale: 2, null: false
      t.decimal :monthly_amortization, precision: 10, scale: 2, null: false
      t.integer :remaining_installments, null: false
      t.integer :status, null: false, default: 0 # active, paid_off

      t.timestamps
    end

    add_index :loans, [:employee_id, :status]
  end
end
