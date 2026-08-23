class AttendanceCorrectionRequest < ApplicationRecord
  belongs_to :employee
  belongs_to :attendance_record, optional: true
  belongs_to :reviewed_by, class_name: "Employee", optional: true

  enum :status, { pending: 0, approved: 1, rejected: 2 }

  validates :date, presence: true
  validates :reason, presence: true
end
