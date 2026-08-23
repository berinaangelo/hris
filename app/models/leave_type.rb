class LeaveType < ApplicationRecord
  belongs_to :company

  has_many :leave_balances, dependent: :destroy
  has_many :leave_requests, dependent: :destroy

  validates :name, presence: true, uniqueness: { scope: :company_id }
end
