---
title: performance-review-kpi-based-not-form-builder
tags: [hris, performance-reviews, ruthless-simplicity]
date: 2026-08-21
---

For [[../projects/hris/features/performance-reviews-goals/PLAN.md|performance reviews/goals]],
chose a KPI-based model with a fixed structure and free-text content,
over a configurable evaluation form builder.

Why not a form builder: configurable field types, per-role/department
templates, versioning, and scoring-rule configuration amount to building
a form-builder product, not a feature — same trap as
[[approval-chains-scrapped-fallback-design|configurable approval chains]].

Why not a single rigid company-wide form either: KPIs genuinely differ
by role (a salesperson's KPI is a quota number, a developer's might be
"ship feature X," a support rep's might be "resolve N tickets at Y
satisfaction"). A single fixed-field form wouldn't fit most roles.

Resolution — fixed structure, variable content: a review cycle holds a
list of KPI entries per employee, each shaped identically
(`kpi_name`, `target`, `actual`, `score`, `comment`, all free text/number
where relevant) — the *content* varies per role, the *structure* never
changes. Covers "goals" too, since a goal is just a non-numeric KPI in
the same shape — no need for two separate systems.

PIP (Performance Improvement Plan) reuses the identical structure: just
a `cycle_type = PIP` flag, shorter `start_date`/`end_date`, an "On PIP"
badge derived from having an active PIP-type cycle, and an `outcome`
field at close (`passed` / `not passed` / `extended`). No separate PIP
module. Any consequence of a PIP outcome (termination, escalation) stays
a manual HR decision outside the system — see
[[ph-hr-payroll-compliance-glossary]] on PH labor-law due-process
requirements around termination.
