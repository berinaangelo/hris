class Payslip < ApplicationRecord
  belongs_to :payroll_run
  belongs_to :employee
  belongs_to :previous_version, class_name: "Payslip", optional: true
  belongs_to :generated_by, class_name: "Employee", optional: true

  has_one :reissued_version, class_name: "Payslip", foreign_key: :previous_version_id,
                              inverse_of: :previous_version, dependent: :nullify
  has_many :payslip_line_items, dependent: :destroy

  enum :status, { draft: 0, finalized: 1, voided: 2 }

  validates :void_reason, presence: true, if: :voided?

  # gross_pay/total_deductions/net_pay are computed once by
  # Payroll::GeneratePayslip and stored, not re-derived on read — a
  # finalized cutoff's figures are locked. See
  # kos/decisions/schema/payroll-v2-schema.md.
end
