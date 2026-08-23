class LeaveBalance < ApplicationRecord
  belongs_to :employee
  belongs_to :leave_type

  validates :year, presence: true, uniqueness: { scope: [:employee_id, :leave_type_id] }
  validates :entitled_days, :used_days, numericality: { greater_than_or_equal_to: 0 }

  # used_days is written by Leave::ApproveRequest / Leave::CancelApprovedRequest
  # (explicit Interactor steps, not an AR callback — see
  # kos/decisions/rails-callback-objects-for-cache-busting.md and the full
  # rollup mechanics in kos/decisions/schema/core-v1-schema.md). This
  # model stays persistence/associations/validations only, per
  # kos/decisions/rails-skinny-models-behavior-in-interactors.md —
  # remaining_days below is trivial arithmetic, not business logic.
  def remaining_days
    entitled_days - used_days
  end
end
