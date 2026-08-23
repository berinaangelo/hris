# Status -> badge-category CSS class, shared across every feature's
# statuses instead of duplicated per view — see
# kos/decisions/rails-presenters-decorators-for-view-formatting.md and
# kos/decisions/ui/badge-system-four-categories.md.
class BadgePresenter
  CATEGORY_BY_STATUS = {
    "pending" => :caution,
    "approved" => :positive,
    "rejected" => :negative,
    "offboarding" => :caution,
    "offboarded" => :neutral,
    "on_time" => :positive,
    "late" => :caution,
    "undertime" => :caution,
    "absent" => :negative,
    "expired" => :negative,
    "expiring_soon" => :caution,
    "passed" => :positive,
    "not_passed" => :negative,
    "extended" => :caution,
    "in_progress" => :caution,
    "awaiting_scoring" => :caution,
    "open" => :positive,
    "closed" => :neutral
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
