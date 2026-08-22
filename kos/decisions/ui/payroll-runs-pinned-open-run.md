---
title: payroll-runs-pinned-open-run
tags: [hris, design, ux, company, admin, payroll]
date: 2026-08-22
---

Chose "Pinned open run + full history" for Payroll Runs — the
HR-Admin landing page for Payroll (Company → Payroll, reached per
[[navigation-me-team-company]]), the first screen of
[[../projects/hris/features/payroll-v2/PLAN.md|payroll v2]] and the
plan's own step 1, "HR opens a pay period" — over a "Flat run history +
toolbar action" (open run is just the first table row) and a "Stat
strip + grouped by year" (year-grouped expandable list, no dedicated
open-run treatment). Full comparison, all three built on the same
tokens: https://claude.ai/code/artifact/1d50993f-3ab4-4651-99c7-3e58670329f3

**Layout — the chosen option:**
- A dark hero card ("Currently open") is pinned above the history
  table: cutoff period, pay date, Open status badge, employee count,
  provisional gross so far, and count of auto-added loan deductions,
  plus a single "Continue payroll run" primary action.
- A caution flag rides inside the hero itself (e.g. "3 employees still
  missing OT entries — resolve before finalizing") rather than
  recoloring the whole card, keeping Open → Neutral honest per
  [[badge-system-four-categories]].
- Below the hero, the full run history sits in the same
  [[data-tables-comfortable-density|comfortable-density table]] pattern
  used elsewhere in the app (cutoff, pay date, type, status, employees,
  gross, net), paginated. Only one run can be open at a time — a real
  business rule, not a UI choice — so the hero never has more than one
  entry.
- Clicking into any run (to add line items, review, or finalize) goes
  to [[payroll-run-detail-master-table-edit-drawer|Payroll Run Detail]];
  nothing here edits a run directly.
- The Dec 24 13th Month Pay run is a normal history row, just flagged
  by type, per [[../thirteenth-month-pay-mandatory-in-ph]].

Built on tokens already decided elsewhere:
[[color-palette-ink-and-amber|Ink & Amber]] palette,
[[type-system-neutral-and-efficient|Archivo/Work Sans/IBM Plex Mono]]
type, [[badge-system-four-categories|four-category badges]], and the
same table/toolbar components already built for
[[compliance-certifications-pinned-attention-full-list|Compliance/
Certifications]] and [[reports-landing-grid-drill-in|Reports]].

**Carried over, not re-decided here:** built ahead of the roadmap, same
as [[my-payslips-pinned-hero-swappable-table|My Payslips]] — payroll v2
engineering is still deferred until after v1 ships, but the Payroll nav
slot is already reserved. Finalizing uses pessimistic locking +
idempotency per
[[../rails-db-transactions-locking-idempotency|the DB operations
decision]] so a double-click can't double-process. Rate tables
(SSS/PhilHealth/Pag-IBIG/BIR) are a separate page, not shown here — see
[[rate-tables-landing-cards-edit-drawer]].

Why this one: the plan's own step 1 — "HR opens a pay period" — is the
entire reason this screen exists, so the open run earns the same
top-of-page treatment My Payslips gave the latest payslip and
Compliance/Certifications gave expired/expiring certs: the one thing
that actually needs a click, fully surfaced, before any history. Flat
Run History treats the open run as just the first table row with a
highlighted rail — nothing distinguishes "needs your attention now"
from "already happened" until a skimming admin reads the Status column.
Stat Strip + Grouped by Year reuses a pattern that earns its keep on
24+ payslips per employee, but a mere ~25 runs a year is a short enough
list that the year grouping adds clicks without paying for itself, and
the open run has to compete for attention with several other rows in
the same visual weight class — undoing exactly what a dedicated hero
buys. Since there's realistically at most one open run at a time, this
screen's main job on most visits is "get back into the run I'm
building," not browsing history — worth the fixed slice of vertical
space the hero costs even on the rare visit with nothing open.

HTML mockup: [[../ux-pages/payroll-runs.html]]
