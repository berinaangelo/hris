---
title: rails-presenters-decorators-for-view-formatting
tags: [hris, rails, backend, ui]
date: 2026-08-21
---

View-specific formatting logic gets a Presenter/Decorator, not
duplicated across views/partials.

**Strongest fit in this project:**
[[../decisions/ui/badge-system-four-categories.md|the badge system]]
already defines a single status→badge-category mapping
(Positive/Caution/Negative/Neutral) reused across leave, payroll, PIP,
recruitment, loans. That mapping belongs in one Presenter, not
re-derived per view.

```ruby
class LeaveRequestPresenter < SimpleDelegator
  def badge_category
    case status
    when "approved" then "positive"
    when "pending"  then "caution"
    when "rejected" then "negative"
    end
  end
end
```

**How to apply:** any time the same piece of display-formatting logic
(status → badge color, currency/date formatting, computed labels) would
otherwise be copy-pasted into more than one view, put it in a
Presenter/Decorator instead.
