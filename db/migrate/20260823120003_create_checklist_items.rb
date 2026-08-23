class CreateChecklistItems < ActiveRecord::Migration[8.1]
  def change
    create_table :checklist_items do |t|
      t.references :employee, null: false, foreign_key: true

      # Onboarding + offboarding share this one table — same shape (a
      # fixed, code-defined list of items per employee, each markable
      # done). See ChecklistItem::ONBOARDING_ITEM_KEYS /
      # OFFBOARDING_ITEM_KEYS for the fixed lists themselves — they live
      # in code, not the DB, per the PLAN's "fixed list, not a workflow
      # builder."
      t.integer :checklist_type, null: false # onboarding, offboarding
      t.string :item_key, null: false
      t.integer :position, null: false
      t.datetime :completed_at

      t.timestamps
    end

    add_index :checklist_items, [:employee_id, :checklist_type, :item_key],
              unique: true, name: "index_checklist_items_on_employee_and_key"
    add_index :checklist_items, [:employee_id, :checklist_type]
  end
end
