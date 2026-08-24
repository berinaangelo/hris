class Employee < ApplicationRecord
  include ChecklistItem::EmployeePredicates

  has_secure_password

  # Rails' built-in secure token support — no reset-token column needed,
  # since the token is derived from the current password digest and
  # therefore auto-invalidates the moment the password changes. 15
  # minutes is a placeholder pending an actual policy decision, per
  # kos/decisions/ui/password-recovery-flow-split-panel.md.
  generates_token_for :password_reset, expires_in: 15.minutes do
    password_salt&.last(10)
  end

  belongs_to :company
  belongs_to :manager, class_name: "Employee", optional: true
  belongs_to :shift_template, optional: true

  has_many :direct_reports, class_name: "Employee", foreign_key: :manager_id, inverse_of: :manager
  has_many :checklist_items, dependent: :destroy
  has_many :documents, dependent: :destroy
  has_many :uploaded_documents, class_name: "Document", foreign_key: :uploaded_by_id, inverse_of: :uploaded_by
  has_many :leave_balances, dependent: :destroy
  has_many :leave_requests, dependent: :destroy
  has_many :approved_leave_requests, class_name: "LeaveRequest", foreign_key: :approver_id, inverse_of: :approver
  has_many :attendance_records, dependent: :destroy
  has_many :attendance_correction_requests, dependent: :destroy
  has_many :review_cycles, dependent: :destroy
  has_many :certifications, dependent: :destroy
  has_many :benefit_enrollments, dependent: :destroy
  has_many :loans, dependent: :destroy
  has_many :payslips, dependent: :destroy
  has_one :hired_from_candidate, class_name: "JobCandidate", foreign_key: :hired_employee_id,
                                  inverse_of: :hired_employee, dependent: :nullify

  enum :role, { employee: 0, manager: 1, admin: 2 }
  enum :status, { active: 0, offboarding: 1, offboarded: 2 }
  enum :employment_type, { full_time: 0, part_time: 1, contract: 2 }

  # The fixed lists checklist_items are seeded from on create/offboard —
  # see kos/decisions/schema/core-v1-schema.md. Lives here rather than
  # on ChecklistItem since "attach the fixed list to this employee" is
  # this model's own lifecycle event.
  ONBOARDING_ITEM_KEYS = %w[
    employment_contract_signed
    government_ids_submitted
    company_equipment_issued
  ].freeze

  OFFBOARDING_ITEM_KEYS = %w[
    equipment_returned
    system_access_revoked
    final_pay_clearance_computed
    exit_interview_completed
  ].freeze

  validates :employee_number, presence: true, uniqueness: { scope: :company_id }
  validates :first_name, :last_name, presence: true
  validates :work_email, presence: true, uniqueness: true,
                          format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :job_title, :department, presence: true
  validates :start_date, presence: true

  before_validation { self.work_email = work_email&.downcase }

  checklist_item_predicates(*ONBOARDING_ITEM_KEYS, *OFFBOARDING_ITEM_KEYS)

  def full_name
    "#{first_name} #{last_name}"
  end
end
