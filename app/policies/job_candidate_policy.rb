# Authorized through the parent JobOpening's company, mirroring how
# other nested-under-a-parent resources (BenefitDependent, KpiEntry) go
# through their parent rather than getting their own company-scoped
# Pundit Scope.
class JobCandidatePolicy < ApplicationPolicy
  def update?
    user.admin? && record.job_opening.company_id == user.company_id
  end

  def hire?
    update?
  end
end
