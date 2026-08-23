class ReviewCycleMailer < ApplicationMailer
  def opened_email(review_cycle)
    @review_cycle = review_cycle
    @employee = review_cycle.employee

    mail(to: @employee.work_email, subject: "Your #{review_cycle.pip? ? "PIP" : "performance review"} cycle has started")
  end

  def published_email(review_cycle)
    @review_cycle = review_cycle
    @employee = review_cycle.employee

    mail(to: @employee.work_email, subject: "Your performance review has been published")
  end
end
