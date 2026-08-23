---
title: recruitment-ats-schema
tags: [hris, schema, database, recruitment-ats]
date: 2026-08-23
---

DB schema for
[[../../projects/hris/features/recruitment-ats/PLAN.md|Recruitment/ATS]].
Depends on [[core-v1-schema]] (`companies`, `employees`). Candidates are
never system users — no login, no `has_secure_password`, an intentional
break from every other person-shaped table in this app.

## job_openings

| Column | Type | Notes |
|---|---|---|
| company_id | bigint, FK, not null | |
| title | string, not null | |
| description | text, nullable | |
| status | integer (enum: open, closed), not null, default `0` | |
| slug | string, not null | generated from `title` (`parameterize`) on create, not user-editable — backs the read-only public apply link (`hris.app/apply/{slug}`), per [[../ui/job-opening-form-right-side-drawer]] |

**Indexes**
- `company_id`
- unique `slug` — also the lookup key for the public, unauthenticated
  application-form route
- `[company_id, status]` — Job Openings' open/closed grid filter

## job_candidates

Everything the public application form
([[../ui/job-application-form-split-panel]]) captures, plus the fixed
pipeline stage and what "Mark Hired" fills in.

| Column | Type | Notes |
|---|---|---|
| job_opening_id | bigint, FK, not null | |
| full_name | string, not null | |
| email | string, not null | |
| phone | string, nullable | |
| note | text, nullable | free-text interview feedback — "a notes field covers it," not a structured scorecard, per the PLAN |
| stage | integer (enum: submitted, interviewing, offer, hired, rejected), not null, default `0` | UI label for `submitted` is "New" — the Rails enum key can't literally be `new`, it would shadow `ActiveRecord::Base.new`; changed via a dropdown, never drag-and-drop, per [[../ui/job-opening-detail-kanban-stage-columns]] |
| applied_at | datetime, not null | |
| consent_given_at | datetime, nullable | Data Privacy Act (RA 10173) consent checkbox — flagged in [[../ui/job-application-form-split-panel]] as "added... not assumed decided," column included since the field is already in the mockup, policy not yet confirmed |
| hired_employee_id | bigint, FK → employees, nullable | set the instant "Create employee record" fires in the Hired Handoff drawer; the actual payoff moment ([[../ui/hired-handoff-review-and-edit-drawer]]) |

Résumé is an Active Storage attachment (`has_one_attached :resume` on
`JobCandidate`), not a column — same pattern as `Document#file` in
[[core-v1-schema]].

**Indexes**
- `job_opening_id`
- `[job_opening_id, stage]` — the kanban board's per-column query and
  count, run on every Job Opening Detail page load
- `hired_employee_id`

No FK/uniqueness ties a candidate's email to one row across openings —
the same person can legitimately apply to more than one opening.

## Rollup mechanics — not needed

Pipeline-stage counts shown on the Job Openings card grid
([[../ui/job-openings-card-grid-with-list-toggle]]) are a `GROUP BY
stage` over one job opening's candidates — at most a few dozen rows per
opening, trivial on the `[job_opening_id, stage]` index. No report reads
across openings/candidates at volume today.

## Related decisions

- [[../../projects/hris/features/recruitment-ats/PLAN.md]]
- [[../ui/job-opening-detail-kanban-stage-columns]]
- [[../ui/hired-handoff-review-and-edit-drawer]]
- [[../ats-checker-reuse-parked-for-recruitment]]
- [[core-v1-schema]]
