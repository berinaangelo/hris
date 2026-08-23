class KpiEntry < ApplicationRecord
  belongs_to :review_cycle

  validates :kpi_name, :target, presence: true
  validates :position, presence: true
  validates :score, inclusion: { in: 1..5 }, allow_nil: true
end
