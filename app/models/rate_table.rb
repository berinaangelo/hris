class RateTable < ApplicationRecord
  belongs_to :company
  belongs_to :updated_by, class_name: "Employee", optional: true

  enum :agency, { sss: 0, philhealth: 1, pagibig: 2, bir: 3 }

  AGENCY_LABELS = { "sss" => "SSS", "philhealth" => "PhilHealth", "pagibig" => "Pag-IBIG", "bir" => "BIR" }.freeze

  validates :agency, uniqueness: { scope: :company_id }
  validates :effective_date, presence: true

  # No effective-dated version history — an edit replaces brackets/
  # fields outright. See kos/decisions/schema/payroll-v2-schema.md.

  # Drives the "Not reviewed in over a year" caution badge from
  # kos/decisions/ui/rate-tables-landing-cards-edit-drawer.md —
  # updated_at rather than effective_date, since an edit (even one that
  # keeps the same effective date) is what actually re-affirms the table.
  def stale?
    updated_at < 1.year.ago
  end

  def display_name
    AGENCY_LABELS.fetch(agency)
  end
end
