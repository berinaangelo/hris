class ReviewCycle < ApplicationRecord
  belongs_to :employee

  has_many :kpi_entries, -> { order(:position) }, dependent: :destroy

  enum :cycle_type, { regular: 0, pip: 1 }
  enum :status, { in_progress: 0, awaiting_scoring: 1, published: 2 }
  enum :outcome, { passed: 0, not_passed: 1, extended: 2 }

  validates :start_date, :end_date, presence: true
  validates :outcome, absence: true, unless: :pip?

  # Overall rating is trivial arithmetic over already-loaded KPI rows,
  # not stored — see kos/decisions/schema/performance-reviews-schema.md.
  def overall_rating
    kpi_entries.filter_map(&:score).then { |scores| scores.sum.to_f / scores.size if scores.any? }
  end
end
