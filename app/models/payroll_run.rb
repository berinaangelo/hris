class PayrollRun < ApplicationRecord
  belongs_to :company
  belongs_to :finalized_by, class_name: "Employee", optional: true

  has_many :payslips, dependent: :destroy

  enum :run_type, { regular: 0, thirteenth_month: 1 }
  enum :status, { open: 0, finalized: 1 }

  validates :period_start, :period_end, :pay_date, presence: true

  # Finalizing uses pessimistic locking + idempotency
  # (payroll_run.with_lock { ... }) inside Payroll::FinalizeRun, not
  # modeled here — see kos/decisions/rails-db-transactions-locking-idempotency.md.
  # "Only one open run per company" is enforced by Payroll::OpenRun,
  # not a DB constraint (MySQL has no partial unique index).
end
