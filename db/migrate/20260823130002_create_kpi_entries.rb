class CreateKpiEntries < ActiveRecord::Migration[8.1]
  def change
    create_table :kpi_entries do |t|
      t.references :review_cycle, null: false, foreign_key: true

      t.string :kpi_name, null: false
      t.string :target, null: false # free text — a quota number, "ship feature X", etc.
      t.string :actual
      t.integer :score # 1-5
      t.text :comment
      t.integer :position, null: false

      t.timestamps
    end
  end
end
