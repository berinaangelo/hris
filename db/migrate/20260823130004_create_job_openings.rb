class CreateJobOpenings < ActiveRecord::Migration[8.1]
  def change
    create_table :job_openings do |t|
      t.references :company, null: false, foreign_key: true

      t.string :title, null: false
      t.text :description
      t.integer :status, null: false, default: 0 # open, closed
      t.string :slug, null: false # generated from title, backs the public apply link

      t.timestamps
    end

    add_index :job_openings, :slug, unique: true
    add_index :job_openings, [:company_id, :status]
  end
end
