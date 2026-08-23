class JobOpeningMailer < ApplicationMailer
  def new_candidate_email(candidate, admin)
    @candidate = candidate
    @job_opening = candidate.job_opening
    @admin = admin

    mail(to: admin.work_email, subject: "New application: #{@job_opening.title}")
  end
end
