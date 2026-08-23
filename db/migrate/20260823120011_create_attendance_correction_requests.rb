class CreateAttendanceCorrectionRequests < ActiveRecord::Migration[8.1]
  def change
    create_table :attendance_correction_requests do |t|
      t.references :employee, null: false, foreign_key: true
      # Null when the punch was missed entirely — no attendance_records
      # row exists yet for that day; `date` carries the day either way.
      t.references :attendance_record, null: true, foreign_key: true

      t.date :date, null: false
      t.datetime :requested_clock_in_at
      t.datetime :requested_clock_out_at
      t.text :reason, null: false

      t.integer :status, null: false, default: 0 # pending, approved, rejected
      # Resolving a correction request already IS the approver step —
      # no separate approval flag needed alongside it.
      t.references :reviewed_by, null: true, foreign_key: { to_table: :employees }
      t.datetime :reviewed_at

      t.timestamps
    end

    add_index :attendance_correction_requests, [:status, :employee_id]
  end
end
