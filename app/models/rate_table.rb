class RateTable < ApplicationRecord
  belongs_to :company
  belongs_to :updated_by, class_name: "Employee", optional: true

  enum :agency, { sss: 0, philhealth: 1, pagibig: 2, bir: 3 }

  validates :agency, uniqueness: { scope: :company_id }
  validates :effective_date, presence: true

  # No effective-dated version history — an edit replaces brackets/
  # fields outright. See kos/decisions/schema/payroll-v2-schema.md.
end
