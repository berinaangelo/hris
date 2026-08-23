class LeaveRequest < ApplicationRecord
  belongs_to :employee
  belongs_to :leave_type
  belongs_to :approver, class_name: "Employee", optional: true

  enum :status, { pending: 0, approved: 1, rejected: 2 }

  validates :start_date, :end_date, :days_requested, presence: true
  validate :end_date_not_before_start_date

  # Date-range overlap needs Arel (an OR/AND combo a plain .where hash
  # can't express cleanly) — see
  # kos/decisions/rails-arel-for-complex-queries.md.
  def self.overlapping(employee_id, start_date, end_date)
    t = arel_table
    where(employee_id: employee_id)
      .where.not(status: :rejected)
      .where(t[:start_date].lteq(end_date).and(t[:end_date].gteq(start_date)))
  end

  private

  def end_date_not_before_start_date
    return if start_date.blank? || end_date.blank?

    errors.add(:end_date, "can't be before the start date") if end_date < start_date
  end
end
