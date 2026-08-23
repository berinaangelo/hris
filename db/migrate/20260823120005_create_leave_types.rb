class CreateLeaveTypes < ActiveRecord::Migration[8.1]
  def change
    create_table :leave_types do |t|
      t.references :company, null: false, foreign_key: true
      t.string :name, null: false

      t.timestamps
    end

    add_index :leave_types, [:company_id, :name], unique: true
  end
end
