---
title: benefits-schema
tags: [hris, schema, database, benefits]
date: 2026-08-23
---

DB schema for [[../../projects/hris/features/benefits/PLAN.md|Benefits]].
Depends on [[core-v1-schema]] (`employees`). Record-keeping only, per
[[../vendor-fragmented-features-record-keeping-only]] — no enrollment
workflow, eligibility rules, or carrier integration, so this is
literally just "what HR typed in after enrolling someone with the
carrier."

## benefit_enrollments

Zero-to-many per employee — an HMO plan alongside a separately-provisioned
life or accident policy is a common PH SME pattern, per
[[../ui/employee-benefits-repeatable-plan-cards]].

| Column | Type | Notes |
|---|---|---|
| employee_id | bigint, FK, not null | |
| plan_name | string, not null | |
| provider | string, not null | |
| effectivity_date | date, not null | |

No status column — "no deviation state to flag for a benefit record,"
per [[../ui/employee-benefits-repeatable-plan-cards]]'s own reasoning
against a badge here.

**Indexes**
- `employee_id`

## benefit_dependents

| Column | Type | Notes |
|---|---|---|
| benefit_enrollment_id | bigint, FK, not null | |
| name | string, not null | |
| relationship | integer (enum: spouse, child, mother, father), not null | |

**Indexes**
- `benefit_enrollment_id`

## Rollup mechanics — not needed

No report reads this data; it's a per-employee profile field, viewed
one employee at a time.

## Related decisions

- [[../../projects/hris/features/benefits/PLAN.md]]
- [[../vendor-fragmented-features-record-keeping-only]]
- [[core-v1-schema]]
