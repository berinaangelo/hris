---
title: rails-pundit-for-authorization
tags: [hris, rails, backend, security]
date: 2026-08-21
---

Authorization goes through Pundit policy classes — one per resource —
instead of scattered `if current_user.manager?` checks spread across
controllers and views.

**Why:** role-based access (employee / manager / admin — three roles,
not a permissions matrix, per
[[../projects/hris/PLAN.md|the v1 building blocks]]) is a core v1
piece, and also drives the
[[navigation-me-team-company|Me/Team/Company nav's]] "absent, not
filtered" rule — a Pundit policy is the one place that logic should
live.

```ruby
class LeaveRequestPolicy < ApplicationPolicy
  def approve?
    user.manager? && record.employee.manager == user
  end
end
```

**How to apply:** any "can this user see/do this" check goes in the
resource's policy class, checked via `authorize`/`policy_scope` in the
controller — not inlined as a conditional in a view or controller
action.
