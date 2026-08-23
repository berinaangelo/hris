class CreateLeaveRequests < ActiveRecord::Migration[8.1]
  def change
    create_table :leave_requests do |t|
      t.references :employee, null: false, foreign_key: true
      t.references :leave_type, null: false, foreign_key: true
      # Resolved from employee.manager_id at submission time — single-level
      # approval only, per approval-chains-scrapped-fallback-design.md
      t.references :approver, null: true, foreign_key: { to_table: :employees }

      t.integer :status, null: false, default: 0 # pending, approved, rejected

      t.date :start_date, null: false
      t.date :end_date, null: false
      t.decimal :days_requested, precision: 5, scale: 2, null: false

      t.text :reason
      # Whether reject requires a note is still an open UX question
      # (time-off-list-plus-modal.md) — column added now since it's
      # cheap, left nullable/unused until decided.
      t.text :decision_note
      t.datetime :decided_at

      t.timestamps
    end

    add_index :leave_requests, [:approver_id, :status]
    add_index :leave_requests, [:employee_id, :start_date, :end_date]
    add_index :leave_requests, :status
  end
end
