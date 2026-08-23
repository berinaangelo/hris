class CreateJobCandidates < ActiveRecord::Migration[8.1]
  def change
    create_table :job_candidates do |t|
      t.references :job_opening, null: false, foreign_key: true
      # Set the instant "Create employee record" fires in the Hired
      # Handoff drawer — see kos/decisions/ui/hired-handoff-review-and-edit-drawer.md
      t.references :hired_employee, null: true, foreign_key: { to_table: :employees }

      t.string :full_name, null: false
      t.string :email, null: false
      t.string :phone
      t.text :note
      t.integer :stage, null: false, default: 0 # submitted ("New" in the UI), interviewing, offer, hired, rejected
      t.datetime :applied_at, null: false
      # Data Privacy Act (RA 10173) consent — field exists in the
      # mockup, policy not yet confirmed, see the schema doc.
      t.datetime :consent_given_at

      t.timestamps
    end

    add_index :job_candidates, [:job_opening_id, :stage]
  end
end
