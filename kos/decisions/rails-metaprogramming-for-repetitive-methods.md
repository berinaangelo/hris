---
title: rails-metaprogramming-for-repetitive-methods
tags: [hris, rails, backend, code-style]
date: 2026-08-21
---

For the HRIS Rails codebase, reach for metaprogramming (`define_method`
loops / small macros) specifically as a **repetition-avoidance tool** —
not as a default style applied everywhere. The trigger is a set of
methods that would otherwise be hand-written near-duplicates, differing
only by a value baked into the method name.

**Canonical example — per-status predicate/bang pairs**, carried over
from the user's own past practice (used before later projects
simplified to Rails' built-in `enum`/AASM):

```ruby
module Statusable
  extend ActiveSupport::Concern

  class_methods do
    def has_statuses(*statuses)
      statuses.each do |status|
        define_method("#{status}?") { self.status.to_s == status.to_s }
        define_method("#{status}!") { update!(status: status.to_s) }
      end
    end
  end
end

class LeaveRequest < ApplicationRecord
  include Statusable
  has_statuses :pending, :approved, :rejected
end
```

**How to apply:** before generating a batch of methods that only
differ by an interpolated name/value (status predicates/bang setters,
per-field getters/setters, per-role permission checks, etc.), default
to a `define_method` loop / small macro instead of writing each one
out longhand. Do NOT reach for metaprogramming for a one-off method, a
small fixed set of genuinely distinct methods, or anything a built-in
Rails feature (like `enum`) already covers better.
