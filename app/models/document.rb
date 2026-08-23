class Document < ApplicationRecord
  belongs_to :employee
  belongs_to :uploaded_by, class_name: "Employee", optional: true

  has_one_attached :file

  enum :category, { contract: 0, government_id: 1, certificate: 2, other: 3 }

  validates :title, presence: true
end
