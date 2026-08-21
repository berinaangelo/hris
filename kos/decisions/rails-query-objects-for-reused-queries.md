---
title: rails-query-objects-for-reused-queries
tags: [hris, rails, backend, database]
date: 2026-08-21
---

Once a `.where` chain shows up in more than one place, or gets
non-trivial, pull it into a Query Object rather than repeating the
logic inline.

Example candidates from the domain: "employees on an active PIP,"
"pending requests for this manager," "leave requests overlapping a
date range" (pairs with [[rails-arel-for-complex-queries]] — an Arel
condition typically lives inside a Query Object).

```ruby
class PendingApprovalsForManager
  def initialize(manager)
    @manager = manager
  end

  def call
    LeaveRequest.where(status: :pending, employee: @manager.direct_reports)
  end
end
```

**How to apply:** a one-off simple `.where` stays inline. Once the same
condition is needed in two places, or the condition itself is complex
enough to deserve a name, extract it.
