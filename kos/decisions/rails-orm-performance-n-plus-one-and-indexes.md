---
title: rails-orm-performance-n-plus-one-and-indexes
tags: [hris, rails, backend, performance]
date: 2026-08-21
---

Standing ORM/performance conventions for the HRIS project — the same
class of pitfalls that shows up in any ORM (Eloquent included), so
called out explicitly rather than assumed.

1. **N+1 queries** — `includes`/`preload`/`eager_load` by default on
   any association touched in a loop (e.g. rendering the Team roster
   with each employee's manager). Use the `bullet` gem in development
   to catch what's missed.
2. **Missing indexes on foreign keys / hot columns** — `manager_id`,
   `status`, `employee_id` on `leave_requests`, etc. Add the index in
   the migration itself, not as an afterthought.
3. **Looped `.save` instead of bulk ops** — `insert_all`/`upsert_all`
   for batch work (payroll line items, statutory rate table syncs)
   instead of N individual saves triggering N sets of
   callbacks/queries.
