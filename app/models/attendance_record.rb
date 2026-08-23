class AttendanceRecord < ApplicationRecord
  belongs_to :employee
  belongs_to :shift_template
  belongs_to :edited_by, class_name: "Employee", optional: true
  belongs_to :edit_approved_by, class_name: "Employee", optional: true

  has_many :attendance_correction_requests, dependent: :nullify

  enum :status, { on_time: 0, late: 1, undertime: 2, absent: 3 }, prefix: true
  enum :edit_approval_status, { not_required: 0, pending: 1, approved: 2 }, prefix: :edit_approval

  validates :date, presence: true
  validates :date, uniqueness: { scope: :employee_id }

  # Late/undertime is resolved by an Attendance::RecordClockOut interactor
  # comparing clock_in_at/clock_out_at against shift_template — a
  # comparison, not a pay computation, per
  # kos/projects/hris/features/time-attendance/PLAN.md. Not implemented
  # here — this model stays persistence/associations/validations only,
  # per kos/decisions/rails-skinny-models-behavior-in-interactors.md.
end
