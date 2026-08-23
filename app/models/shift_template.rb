class ShiftTemplate < ApplicationRecord
  belongs_to :company

  has_many :employees, dependent: :nullify
  has_many :attendance_records, dependent: :restrict_with_error

  validates :name, presence: true
  validates :start_time, :end_time, presence: true
end
