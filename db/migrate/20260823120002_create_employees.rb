class CreateEmployees < ActiveRecord::Migration[8.1]
  def change
    create_table :employees do |t|
      t.references :company, null: false, foreign_key: true
      # Self-referential — null for the top of the org (e.g. the sole
      # Admin/HR head). shift_template_id is added later, once
      # shift_templates exists (see AddShiftTemplateToEmployees).
      t.references :manager, null: true, foreign_key: { to_table: :employees }

      t.string :employee_number, null: false

      # role/status are plain Rails enum — see
      # kos/decisions/rails-metaprogramming-for-repetitive-methods.md:
      # enum already gives the predicate/bang methods that decision
      # warns against hand-rolling.
      t.integer :role, null: false, default: 0 # employee, manager, admin
      t.integer :status, null: false, default: 0 # active, offboarding, offboarded

      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :work_email, null: false
      t.string :personal_email

      t.string :password_digest, null: false
      t.datetime :password_changed_at
      t.datetime :last_login_at

      # Employee-edited, per my-profile-summary-plus-modal.md
      t.string :mobile_number
      t.string :home_address
      t.date :birthdate
      t.string :emergency_contact_name
      t.string :emergency_contact_phone

      # HR-managed employment facts
      t.string :job_title, null: false
      t.string :department, null: false
      t.integer :employment_type, null: false, default: 0 # full_time, part_time, contract
      t.date :start_date, null: false

      # Offboarding — see ui/offboarding-flow-schedule-clearance-tracker.md
      t.date :last_working_day
      t.string :offboarding_reason
      t.boolean :rehire_eligible
      t.text :offboarding_notes

      # Account settings notification toggles — instant, no save step,
      # per ui/account-settings-summary-plus-modal.md
      t.boolean :leave_request_updates_notifications, null: false, default: true
      t.boolean :new_payslip_notifications, null: false, default: true
      t.boolean :review_cycle_notifications, null: false, default: true
      t.boolean :company_announcement_notifications, null: false, default: true

      # Optimistic locking on profile edits — see
      # kos/decisions/rails-db-transactions-locking-idempotency.md
      t.integer :lock_version, null: false, default: 0

      t.timestamps
    end

    add_index :employees, :work_email, unique: true
    add_index :employees, [:company_id, :employee_number], unique: true
    add_index :employees, [:company_id, :status]
    add_index :employees, [:company_id, :role]
  end
end
