class CreatePayslipLineItems < ActiveRecord::Migration[8.1]
  def change
    create_table :payslip_line_items do |t|
      t.references :payslip, null: false, foreign_key: true
      # Set when source: loan — which loan generated this deduction, so
      # the payroll-run interactor can decrement remaining_installments.
      t.references :loan, null: true, foreign_key: true

      t.integer :line_type, null: false
      # base_salary, bonus, overtime, cash_advance, other_deduction,
      # loan_repayment, statutory_sss, statutory_philhealth,
      # statutory_pagibig, statutory_bir
      t.integer :direction, null: false # earning, deduction
      t.integer :source, null: false # base, manual, loan, statutory
      t.string :description
      t.decimal :amount, precision: 10, scale: 2, null: false

      t.timestamps
    end
  end
end
