class BenefitEnrollment < ApplicationRecord
  belongs_to :employee

  has_many :benefit_dependents, dependent: :destroy

  validates :plan_name, :provider, presence: true
  validates :effectivity_date, presence: true
end
