module Certifications
  # Reused by CertificationsController#index. Company-scoping delegates to
  # CertificationPolicy::Scope rather than duplicating it, per
  # kos/decisions/rails-query-objects-for-reused-queries.md.
  class Filtered
    def self.call(viewer:, search: nil, status: nil)
      scope = CertificationPolicy::Scope.new(viewer, Certification).resolve.includes(:employee)

      if search.present?
        scope = scope.joins(:employee).where(
          "certifications.cert_name LIKE :q OR employees.first_name LIKE :q OR employees.last_name LIKE :q",
          q: "%#{search}%"
        )
      end

      case status
      when "expired" then scope.expired.sorted_by_expiry
      when "expiring_soon" then scope.expiring_soon.sorted_by_expiry
      when "valid" then scope.where("expiry_date > ?", Certification::EXPIRING_SOON_WINDOW.from_now.to_date).sorted_by_expiry
      else scope.sorted_by_expiry
      end
    end
  end
end
