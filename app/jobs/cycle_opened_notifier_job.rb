class CycleOpenedNotifierJob < ApplicationJob
  def perform(review_cycle)
    return unless review_cycle.employee.review_cycle_notifications

    ReviewCycleMailer.opened_email(review_cycle).deliver_now
  end
end
