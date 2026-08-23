# Record-level policy for a ReviewCycle. Powers "My Reviews" (via
# Scope, self only) and the manager-editable actions on Team Reviews.
# Company Reviews' own roster/index/new/create gates live on the
# headless CompanyReviewCyclePolicy instead, since that page isn't
# scoped to one ReviewCycle record — see
# kos/decisions/ui/navigation-me-team-company.md.
class ReviewCyclePolicy < ApplicationPolicy
  # Every employee can view their own review history — Scope narrows
  # what "index" actually returns to just their own cycles.
  def index?
    true
  end

  def show?
    record.employee == user || managed_by_viewer? || user.admin?
  end

  def create?
    user.admin? || (user.manager? && record.employee.manager == user)
  end

  def update?
    !record.published? && (user.admin? || (user.manager? && record.employee.manager == user))
  end

  def save_draft?
    update?
  end

  def publish?
    update?
  end

  class Scope < Scope
    def resolve
      scope.where(employee: user)
    end
  end

  private

  def managed_by_viewer?
    user.manager? && record.employee.manager == user
  end
end
