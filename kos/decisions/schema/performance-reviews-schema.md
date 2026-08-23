---
title: performance-reviews-schema
tags: [hris, schema, database, performance-reviews-goals]
date: 2026-08-23
---

DB schema for
[[../../projects/hris/features/performance-reviews-goals/PLAN.md|Performance
Reviews/Goals]]. Depends on [[core-v1-schema]] (`employees`). Fixed
structure/variable content, per
[[../performance-review-kpi-based-not-form-builder]] — two tables, no
form-builder machinery.

## review_cycles

PIP is not a separate module — `cycle_type` is the only thing that
changes, per
[[../performance-review-kpi-based-not-form-builder]]. No `company_id`
column: [[../ui/company-reviews-roster-filterable-grid-list|Company
Reviews]]' company-wide roster filters through `employees.company_id`
via a join — at SME headcount that join costs nothing, so the column
isn't duplicated here.

| Column | Type | Notes |
|---|---|---|
| employee_id | bigint, FK, not null | |
| cycle_type | integer (enum: regular, pip), not null, default `0` | |
| status | integer (enum: in_progress, awaiting_scoring, published), not null, default `0` | `awaiting_scoring` = past `end_date`, scores being drafted (Save Draft); `published` = locked read-only, per the PLAN's "same treatment as a closed payroll run" |
| outcome | integer (enum: passed, not_passed, extended), nullable | PIP-only, set at close; always null for `cycle_type: regular` |
| start_date | date, not null | |
| end_date | date, not null | |
| manager_comment | text, nullable | the cycle-level comment shown in My Reviews' detail panel |
| published_at | datetime, nullable | |

**Indexes**
- `employee_id`
- `[employee_id, cycle_type, status]` — the "On PIP" badge query
  (`employees.review_cycles.pip.in_progress.exists?`) and My/Team
  Reviews' own rail queries
- `status`

"On PIP" is derived live from this index, not a stored flag on
`employees` — avoids a second place that state can go stale relative
to the cycle's own dates/status.

## kpi_entries

| Column | Type | Notes |
|---|---|---|
| review_cycle_id | bigint, FK, not null | |
| kpi_name | string, not null | |
| target | string, not null | free text — "a quota number," "ship feature X," "resolve N tickets" all fit one column, per [[../performance-review-kpi-based-not-form-builder]] |
| actual | string, nullable | filled at cycle end |
| score | integer, nullable | 1–5 |
| comment | text, nullable | per-KPI comment |
| position | integer, not null | display order |

**Indexes**
- `review_cycle_id`

Overall rating (shown in the rail/detail panel) is **not stored** —
`review_cycle.kpi_entries.average(:score)`, a handful of rows already
loaded whenever a cycle's detail is shown, per
[[../rails-skinny-models-behavior-in-interactors]]'s allowance for
trivial arithmetic reads (same treatment as `LeaveBalance#remaining_days`
in [[core-v1-schema]]).

## Rollup mechanics — not needed

No report reads across cycles at volume yet — My/Team/Company Reviews
all scope to one employee or one company's current roster (tens of
cycles a year per company). If
[[../../projects/hris/features/basic-reporting/PLAN.md|basic-reporting]]
ever adds a reviews-specific report, revisit then; nothing here
justifies a summary table today.

## Related decisions

- [[../../projects/hris/features/performance-reviews-goals/PLAN.md]]
- [[../performance-review-kpi-based-not-form-builder]]
- [[core-v1-schema]]
