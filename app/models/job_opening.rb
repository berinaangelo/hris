class JobOpening < ApplicationRecord
  belongs_to :company

  has_many :job_candidates, dependent: :destroy

  enum :status, { open: 0, closed: 1 }

  validates :title, presence: true
  validates :slug, presence: true, uniqueness: true

  before_validation { self.slug = title.parameterize if slug.blank? && title.present? }
end
