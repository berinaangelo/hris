class PayslipLineItem < ApplicationRecord
  belongs_to :payslip
  belongs_to :loan, optional: true

  enum :line_type, {
    base_salary: 0, bonus: 1, overtime: 2, cash_advance: 3, other_deduction: 4,
    loan_repayment: 5, statutory_sss: 6, statutory_philhealth: 7,
    statutory_pagibig: 8, statutory_bir: 9, thirteenth_month_pay: 10
  }
  enum :direction, { earning: 0, deduction: 1 }
  enum :source, { base: 0, manual: 1, loan: 2, statutory: 3 }

  validates :amount, presence: true, numericality: { greater_than: 0 }
end
