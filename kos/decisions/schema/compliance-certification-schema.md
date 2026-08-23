---
title: compliance-certification-schema
tags: [hris, schema, database, compliance-certification-tracking]
date: 2026-08-23
---

DB schema for
[[../../projects/hris/features/compliance-certification-tracking/PLAN.md|Compliance/Certification
Tracking]]. Depends on [[core-v1-schema]] (`employees`). Deliberately the
smallest table in the schema — the PLAN itself frames this as "two
fields, one scheduled job, one list view."

## certifications

| Column | Type | Notes |
|---|---|---|
| employee_id | bigint, FK, not null | |
| cert_name | string, not null | |
| expiry_date | date, not null | |

No `issuing_body`, `cert_number`, or document upload — explicitly out
of scope per the PLAN, and per
[[../ui/compliance-certification-form-right-side-drawer]] the Add/Edit
form doesn't reopen that scope. Deleting a certification is a hard
`DELETE`, not a soft-delete/archive — "the underlying list has no
version history, so there's nothing to soft-delete or restore," per
that same decision.

Status (Expired / Expiring soon / Valid) is **not a column** — derived
live from `expiry_date` against a fixed 30-day window (`Certification
.expiring_soon` / `.expired` scopes), since the window itself is
hardcoded, not configurable, per the PLAN's own "no settings screen"
scope.

**Indexes**
- `employee_id`
- `expiry_date` — powers both the sorted list
  ([[../ui/compliance-certifications-pinned-attention-full-list]]'s
  "sorted ascending by expiry date") and the daily scheduled check

```ruby
# Daily scheduled job (Solid Queue recurring, per
# rails-activejob-solid-queue-for-background-work.md):
# Compliance::CheckExpiringCertifications scans
# certifications.where(expiry_date: Date.current..30.days.from_now)
# and notifies HR — reuses the v1 notification system (email), not a
# new channel, per the PLAN's own "reuses the notification system
# already built" framing.
```

## Rollup mechanics — not needed

One flat sorted list at real-world scale (a handful to a few dozen
licensed staff per SME) — no aggregate report reads this table today.

## Related decisions

- [[../../projects/hris/features/compliance-certification-tracking/PLAN.md]]
- [[../ui/compliance-certifications-pinned-attention-full-list]]
- [[../ui/compliance-certification-form-right-side-drawer]]
- [[core-v1-schema]]
