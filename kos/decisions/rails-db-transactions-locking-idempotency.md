---
title: rails-db-transactions-locking-idempotency
tags: [hris, rails, backend, database]
date: 2026-08-21
---

Standing DB operation conventions for the HRIS project.

**1. Transactions for multi-step writes, with an Interactor-specific
gotcha.** The `interactor` gem's `.call` (see
[[rails-thin-controllers-organizer-interactor-pattern]]) swallows
failures into `context.success?/failure?` without raising — wrapping
plain `.call` in `ActiveRecord::Base.transaction { ... }` will NOT roll
back on a failed step, since nothing raises. Use `.call!` (raises
`Interactor::Failure`) inside the transaction block for real atomicity:

```ruby
ActiveRecord::Base.transaction do
  Employees::Onboard.call!(employee_params: params, manager_id: manager_id)
end
```

An Interactor step's own `rollback` method is for compensating
*non-transactional* side effects (an already-sent notification, an
external API call) — not a substitute for wrapping the actual
multi-model write in a real DB transaction.

**2. Optimistic locking (`lock_version`)** for records where a rare
concurrent edit should surface as "someone else changed this," not
silently clobber. Fits leave balance updates, review score edits,
profile edits — places where a conflict is unusual but must be caught.

```ruby
# migration: add_column :leave_balances, :lock_version, :integer, default: 0
rescue ActiveRecord::StaleObjectError
  context.fail!(message: "This record was changed by someone else — please retry.")
```

**3. Idempotency — two levels.** DB-level uniqueness constraints
prevent accidental duplicates (a double-submitted form creating two
identical leave requests). For genuinely high-stakes single-processing
operations — payroll run finalization is the clear case — that's a
**pessimistic locking** problem instead: two simultaneous "finalize"
clicks need to serialize, not error out to a user.

```ruby
payroll_run.with_lock do
  return if payroll_run.finalized?
  payroll_run.finalize!
end
```

**Why the optimistic-vs-pessimistic split:** user-facing edits (rare
conflict, fine to ask the user to retry) get optimistic locking;
must-not-double-process operations (payroll finalization) get
pessimistic locking so the second request waits/no-ops instead of
racing.
