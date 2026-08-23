class CreateCompanies < ActiveRecord::Migration[8.1]
  def change
    create_table :companies do |t|
      t.string :name, null: false
      t.string :timezone, null: false, default: "Asia/Manila"

      # Time & attendance company-level toggles — see
      # kos/decisions/time-attendance-correction-request-and-manual-edit.md.
      # Kept here rather than a separate settings table: v1 has only two
      # boolean toggles total, not worth a key-value table yet.
      t.boolean :attendance_manual_edit_enabled, null: false, default: true
      t.boolean :attendance_approvers_enabled, null: false, default: false

      t.timestamps
    end
  end
end
