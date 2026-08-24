# Employee#status -> badge-category CSS class. Kept separate from
# BadgePresenter rather than extending its CATEGORY_BY_STATUS map,
# since that map already assigns "active" => :neutral for a different
# domain (loans) — employee "Active" reads as :positive per
# kos/decisions/ux-pages/{account-settings,my-profile}.html and
# kos/decisions/ui/badge-system-four-categories.md.
#
# "offboarded" => :neutral (not :negative) — Offboarding is the Caution
# state, Offboarded is a calm terminal state, matching BadgePresenter's
# own "offboarded" => :neutral mapping and
# kos/decisions/ui/offboarding-flow-schedule-clearance-tracker.md.
class EmployeeStatusPresenter
  CATEGORY_BY_STATUS = {
    "active" => :positive,
    "offboarding" => :caution,
    "offboarded" => :neutral
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
