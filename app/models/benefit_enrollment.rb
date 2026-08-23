class BenefitEnrollment < ApplicationRecord
  belongs_to :employee

  has_many :benefit_dependents, dependent: :destroy
  accepts_nested_attributes_for :benefit_dependents, allow_destroy: true, reject_if: :all_blank

  validates :plan_name, :provider, presence: true
  validates :effectivity_date, presence: true
end
