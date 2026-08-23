class NewCandidateNotifierJob < ApplicationJob
  def perform(candidate, admin)
    JobOpeningMailer.new_candidate_email(candidate, admin).deliver_now
  end
end
