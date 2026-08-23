class CyclePublishedNotifierJob < ApplicationJob
  def perform(review_cycle)
    return unless review_cycle.employee.review_cycle_notifications

    ReviewCycleMailer.published_email(review_cycle).deliver_now
  end
end
