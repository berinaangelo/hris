class Company < ApplicationRecord
  has_many :employees, dependent: :destroy
  has_many :leave_types, dependent: :destroy
  has_many :shift_templates, dependent: :destroy
  has_many :job_openings, dependent: :destroy
  has_many :payroll_runs, dependent: :destroy
  has_many :rate_tables, dependent: :destroy

  validates :name, presence: true
  validates :timezone, presence: true

  def today
    Time.current.in_time_zone(timezone).to_date
  end
end
