class Certification < ApplicationRecord
  EXPIRING_SOON_WINDOW = 30.days

  belongs_to :employee

  validates :cert_name, presence: true
  validates :expiry_date, presence: true

  scope :expired, -> { where("expiry_date < ?", Date.current) }
  scope :expiring_soon, -> { where(expiry_date: Date.current..EXPIRING_SOON_WINDOW.from_now.to_date) }
  scope :sorted_by_expiry, -> { order(:expiry_date) }

  def expired?
    expiry_date < Date.current
  end

  def expiring_soon?
    !expired? && expiry_date <= EXPIRING_SOON_WINDOW.from_now.to_date
  end
end
