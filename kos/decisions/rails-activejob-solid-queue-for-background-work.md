---
title: rails-activejob-solid-queue-for-background-work
tags: [hris, rails, backend, infrastructure]
date: 2026-08-21
---

Anything that doesn't need to happen synchronously in the
request/Interactor goes through ActiveJob, not inline. Direct fit: per
[[notifications-nav-badge-counts|the notification decision]], email is
the actual v1 "you were told to act" channel (leave request
submitted/decided, review published, etc.) — that send belongs in a
background job so a slow SMTP call never blocks the request/Interactor
step that triggered it.

```ruby
class LeaveDecisionNotifierJob < ApplicationJob
  def perform(leave_request)
    LeaveRequestMailer.decision_email(leave_request).deliver_now
  end
end
```

Called from the relevant Interactor step (see
[[rails-thin-controllers-organizer-interactor-pattern]]) as
`LeaveDecisionNotifierJob.perform_later(leave_request)`, not delivered
inline.

**Adapter: Solid Queue, not Sidekiq.** DB-backed (runs on the MySQL
already in the stack per
[[../projects/hris/PLAN.md|the tech stack]]), no separate Redis
service to provision/operate, Rails 8 default from the same team as
Turbo/Stimulus. Native recurring-job support via
`config/recurring.yml` covers the statutory rate-table-sync case
without needing Sidekiq Pro/Enterprise. `mission_control-jobs` gives
the web dashboard equivalent to Sidekiq Web. GoodJob/Que were ruled
out outright — both Postgres-only, and this stack is MySQL. Revisit
only if job volume/latency needs genuinely outgrow DB-backed dispatch,
which isn't expected for this product's job types (transactional
emails, payroll-run notifications, rate syncs).

**How to apply:** default to `perform_later` for emails and any other
non-critical-path work; keep `perform_now`/inline only for something
the response genuinely depends on.
