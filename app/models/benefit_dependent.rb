class BenefitDependent < ApplicationRecord
  belongs_to :benefit_enrollment

  enum :relationship, { spouse: 0, child: 1, mother: 2, father: 3 }

  validates :name, presence: true
end
