class CreateAttendanceRecords < ActiveRecord::Migration[8.1]
  def change
    create_table :attendance_records do |t|
      t.references :employee, null: false, foreign_key: true
      # Snapshot of the employee's shift assignment AT PUNCH TIME, not a
      # live read off employees.shift_template_id — an assignment can
      # change later, but a historical day's late/undertime flag must
      # keep comparing against the shift actually in effect that day.
      t.references :shift_template, null: false, foreign_key: true

      t.date :date, null: false
      t.datetime :clock_in_at
      t.datetime :clock_out_at
      t.integer :status # on_time, late, undertime, absent — resolved at clock-out

      # Manual edit — supervisor or admin, gated by
      # companies.attendance_manual_edit_enabled at the policy/interactor
      # level (not a DB constraint). See
      # kos/decisions/time-attendance-correction-request-and-manual-edit.md
      t.boolean :manually_edited, null: false, default: false
      t.references :edited_by, null: true, foreign_key: { to_table: :employees }
      t.datetime :edited_at

      # Optional attendance-approver sign-off. Only moves off
      # not_required when companies.attendance_approvers_enabled is on.
      # NEVER gates payroll — oversight only, read by nothing else.
      t.integer :edit_approval_status, null: false, default: 0 # not_required, pending, approved
      t.references :edit_approved_by, null: true, foreign_key: { to_table: :employees }
      t.datetime :edit_approved_at

      t.timestamps
    end

    add_index :attendance_records, [:employee_id, :date], unique: true
    add_index :attendance_records, [:employee_id, :status]
    add_index :attendance_records, :date
  end
end
