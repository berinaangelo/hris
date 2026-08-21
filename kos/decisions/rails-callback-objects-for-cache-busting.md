---
title: rails-callback-objects-for-cache-busting
tags: [hris, rails, backend, caching]
date: 2026-08-21
---

Split where model-lifecycle side effects live, based on whether they
must fire on *every* write or only within one specific business flow.

**Cache busting → ActiveRecord callback object.** Must happen on every
write regardless of entry point (console, rake task, admin edit, an
Interactor) — so it goes through a callback object registered on the
model, not duplicated per Interactor:

```ruby
class EmployeeCacheInvalidator
  def after_commit(employee)
    Rails.cache.delete("employee/#{employee.id}")
  end
end

class Employee < ApplicationRecord
  after_commit EmployeeCacheInvalidator.new
end
```

This is the closest Rails-native equivalent to Laravel's Observer
classes — `ActiveRecord::Observer` itself was deprecated/removed from
Rails core in 4.0; passing an object (not a symbol) to a callback is
the modern replacement, and it keeps the actual logic out of the model
body, consistent with
[[rails-skinny-models-behavior-in-interactors]].

**Everything else → explicit Interactor step**, not a model callback.
Business-flow-specific side effects (e.g. "notify the manager when a
leave request is submitted") stay visible in the Organizer's
`organize` list (see
[[rails-thin-controllers-organizer-interactor-pattern]] and
[[rails-activejob-solid-queue-for-background-work]]) rather than
buried as an implicit callback that only fires through one code path
anyway.

**Why:** the project leans explicit-over-implicit (Organizer steps
over hidden side effects) everywhere else already decided — this keeps
that consistent while still giving cross-cutting concerns like caching
a real home.
