class CreateBenefitEnrollments < ActiveRecord::Migration[8.1]
  def change
    create_table :benefit_enrollments do |t|
      t.references :employee, null: false, foreign_key: true

      t.string :plan_name, null: false
      t.string :provider, null: false
      t.date :effectivity_date, null: false

      t.timestamps
    end
  end
end
