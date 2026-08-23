class CreateDocuments < ActiveRecord::Migration[8.1]
  def change
    create_table :documents do |t|
      t.references :employee, null: false, foreign_key: true
      t.references :uploaded_by, null: true, foreign_key: { to_table: :employees }

      t.string :title, null: false
      t.integer :category, null: false, default: 3 # contract, government_id, certificate, other

      t.timestamps
    end
  end
end

# The actual file lives in Active Storage (has_one_attached :file on
# Document), not a column here — see
# db/migrate/20260823120000_create_active_storage_tables.active_storage.rb
