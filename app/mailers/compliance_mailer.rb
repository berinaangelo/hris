class ComplianceMailer < ApplicationMailer
  def expiring_certifications_digest_email(admin, certifications)
    @admin = admin
    @certifications = certifications

    mail(to: @admin.work_email, subject: "#{@certifications.size} certification(s) expiring soon")
  end
end
