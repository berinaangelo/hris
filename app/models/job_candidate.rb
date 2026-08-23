class JobCandidate < ApplicationRecord
  belongs_to :job_opening
  belongs_to :hired_employee, class_name: "Employee", optional: true

  has_one_attached :resume

  # `submitted` is stage 0, shown in the UI as "New" — `new` itself is
  # off-limits as an enum key, it would shadow ActiveRecord::Base.new.
  enum :stage, { submitted: 0, interviewing: 1, offer: 2, hired: 3, rejected: 4 }, prefix: :stage

  validates :full_name, :email, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :applied_at, presence: true
end
