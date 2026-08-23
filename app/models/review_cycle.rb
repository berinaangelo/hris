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

  # Editable once status already says awaiting_scoring, or once the
  # cycle's end date has passed even though nothing has flipped status
  # yet — there's no automated scheduling (out of scope per
  # kos/projects/hris/features/performance-reviews-goals/PLAN.md), so
  # this is evaluated live on every read rather than a stored
  # transition. The manager's first save
  # (see ReviewCycles::SaveDraftScores) persists status: :awaiting_scoring
  # for good.
  def scoring_open?
    awaiting_scoring? || (in_progress? && Date.current > end_date)
  end
end
