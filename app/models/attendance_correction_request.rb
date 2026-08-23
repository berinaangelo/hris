class AttendanceCorrectionRequest < ApplicationRecord
  belongs_to :employee
  belongs_to :attendance_record, optional: true
  belongs_to :reviewed_by, class_name: "Employee", optional: true

  enum :status, { pending: 0, approved: 1, rejected: 2 }

  validates :date, presence: true
  validates :reason, presence: true
  validate :requests_at_least_one_clock_time

  def self.pending_for(employee_id, date)
    pending.where(employee_id: employee_id, date: date)
  end

  private

  def requests_at_least_one_clock_time
    return if requested_clock_in_at.present? || requested_clock_out_at.present?

    errors.add(:base, "must request a corrected clock in or clock out time")
  end
end
