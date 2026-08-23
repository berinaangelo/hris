class Loan < ApplicationRecord
  belongs_to :employee

  has_many :payslip_line_items, dependent: :nullify

  enum :loan_type, { sss_salary_loan: 0, pagibig_mpl: 1, pagibig_calamity: 2, company_loan: 3 }
  enum :status, { active: 0, paid_off: 1 }

  validates :total_amount, :monthly_amortization, presence: true, numericality: { greater_than: 0 }
  validates :remaining_installments, presence: true, numericality: { greater_than_or_equal_to: 0 }

  # remaining_installments is decremented by Payroll::AddLoanDeductions
  # each run, not a callback here — see
  # kos/decisions/rails-callback-objects-for-cache-busting.md and
  # kos/decisions/schema/payroll-v2-schema.md.
end
