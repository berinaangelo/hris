class CreateReviewCycles < ActiveRecord::Migration[8.1]
  def change
    create_table :review_cycles do |t|
      t.references :employee, null: false, foreign_key: true

      t.integer :cycle_type, null: false, default: 0 # regular, pip
      t.integer :status, null: false, default: 0 # in_progress, awaiting_scoring, published
      t.integer :outcome # passed, not_passed, extended — PIP-only

      t.date :start_date, null: false
      t.date :end_date, null: false
      t.text :manager_comment
      t.datetime :published_at

      t.timestamps
    end

    add_index :review_cycles, [:employee_id, :cycle_type, :status],
              name: "index_review_cycles_on_employee_type_status"
    add_index :review_cycles, :status
  end
end
