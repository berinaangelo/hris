---
title: rails-arel-for-complex-queries
tags: [hris, rails, backend, database]
date: 2026-08-21
---

Reach for Arel (`Model.arel_table`) once a query outgrows what a plain
`.where(...)` hash can express cleanly — `OR` combinations across
columns, date-range overlap checks, dynamic SQL comparisons. An
Arel-built condition typically lives inside a
[[rails-query-objects-for-reused-queries|Query Object]] or a model
class method, not inline in a controller.

**Canonical example for this domain** — leave request date-range
overlap, a real HRIS need (validating a new request doesn't overlap an
existing approved one):

```ruby
class LeaveRequest < ApplicationRecord
  def self.overlapping(start_date, end_date)
    t = arel_table
    where(t[:start_date].lteq(end_date).and(t[:end_date].gteq(start_date)))
  end
end
```

**How to apply:** default to plain ActiveRecord `.where` for simple
equality/range conditions; reach for Arel once the condition needs
boolean composition (`.and`/`.or`/`.not`) across columns or SQL-level
comparisons that don't map cleanly to a hash.
