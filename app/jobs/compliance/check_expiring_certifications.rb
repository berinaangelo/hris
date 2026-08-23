module Compliance
  # Daily scan for certifications entering the 30-day expiry window —
  # scoped to Certification.expiring_soon only (not .expired), per
  # kos/decisions/schema/compliance-certification-schema.md's literal
  # "scans certifications.where(expiry_date: Date.current..30.days.from_now)"
  # and the PLAN's own 30-day-lookahead framing. One digest email per
  # company admin per day (see ComplianceMailer), not one per cert.
  class CheckExpiringCertifications < ApplicationJob
    def perform
      Certification.expiring_soon.includes(employee: :company).group_by { |certification| certification.employee.company }.each do |company, certifications|
        company.employees.admin.each do |admin|
          next unless admin.compliance_certification_notifications

          ComplianceMailer.expiring_certifications_digest_email(admin, certifications).deliver_now
        end
      end
    end
  end
end
