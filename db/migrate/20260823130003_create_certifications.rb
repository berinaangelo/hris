class CreateCertifications < ActiveRecord::Migration[8.1]
  def change
    create_table :certifications do |t|
      t.references :employee, null: false, foreign_key: true

      t.string :cert_name, null: false
      t.date :expiry_date, null: false

      t.timestamps
    end

    add_index :certifications, :expiry_date
  end
end
