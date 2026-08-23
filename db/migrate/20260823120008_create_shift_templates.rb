class CreateShiftTemplates < ActiveRecord::Migration[8.1]
  def change
    create_table :shift_templates do |t|
      t.references :company, null: false, foreign_key: true
      t.string :name, null: false
      t.time :start_time, null: false
      t.time :end_time, null: false

      t.timestamps
    end
  end
end
