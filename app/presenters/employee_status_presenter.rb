# Employee#status -> badge-category CSS class. Kept separate from
# BadgePresenter rather than extending its CATEGORY_BY_STATUS map,
# since that map already assigns "active" => :neutral for a different
# domain (loans) — employee "Active" reads as :positive per
# kos/decisions/ux-pages/{account-settings,my-profile}.html and
# kos/decisions/ui/badge-system-four-categories.md.
class EmployeeStatusPresenter
  CATEGORY_BY_STATUS = {
    "active" => :positive,
    "offboarding" => :caution,
    "offboarded" => :negative
  }.freeze

  def initialize(status)
    @status = status.to_s
  end

  def category
    CATEGORY_BY_STATUS.fetch(@status, :neutral)
  end

  def css_class
    "badge badge-#{category}"
  end

  def label
    @status.humanize
  end
end
