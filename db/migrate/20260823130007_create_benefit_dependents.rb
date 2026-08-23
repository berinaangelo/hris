class CreateBenefitDependents < ActiveRecord::Migration[8.1]
  def change
    create_table :benefit_dependents do |t|
      t.references :benefit_enrollment, null: false, foreign_key: true

      t.string :name, null: false
      t.integer :relationship, null: false # spouse, child, mother, father

      t.timestamps
    end
  end
end
