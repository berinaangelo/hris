# Performance Reviews/Goals — Plan

Status: post-MVP backlog — scoped, not committed to a version
Last updated: 2026-08-21

## One-sentence description

A manager sets a short list of KPIs for an employee each review cycle,
scores them against actual results at cycle end, and PIP is just a
shorter, flagged version of the same cycle.

## Core flow

1. HR/manager opens a review cycle for an employee.
2. Adds 3–5 KPI entries (name, target).
3. Cycle runs.
4. Manager fills in actual results + score + comment per KPI at cycle
   end.
5. Overall rating = average of scores.
6. Employee is notified and can view the finished review.

## In scope

- Review cycle per employee — `cycle_type` (`regular` / `PIP`),
  `start_date`, `end_date`
- KPI entries per cycle — `kpi_name`, `target`, `actual`, `score`
  (1–5), `comment` — free text, so content fits any role without a form
  builder (see [[performance-review-kpi-based-not-form-builder]])
- Overall rating — simple average of KPI scores
- Notification on cycle open and on publish (reuses the notification
  system from [[../../PLAN.md|v1]])
- Employee view of their own finished reviews
- PIP-specific additions:
  - "On PIP" badge on the employee profile, derived from an active
    PIP-type cycle (today between start/end dates)
  - `outcome` field at cycle close — `passed` / `not passed` /
    `extended`
  - Finalized cycles lock read-only (same treatment as a closed
    payroll run)

## Out of scope

- Configurable form builder (custom field types, per-department
  templates)
- Weighted scoring, multiple rating scales
- 360/peer review, formal self-review step
- Automated review cycle scheduling — HR opens cycles manually
- Any automatic consequence tied to a PIP outcome (termination flags,
  auto-escalation, legal notices) — stays a manual HR decision outside
  the system, given PH labor-law due-process requirements (see
  [[ph-hr-payroll-compliance-glossary]])

## Related decisions

- [[performance-review-kpi-based-not-form-builder]]
