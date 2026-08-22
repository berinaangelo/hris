---
title: reports-landing-grid-drill-in
tags: [hris, design, ux, company, admin]
date: 2026-08-22
---

Chose "Landing Grid, Drill-in" for Reports — the HR-Admin-only fixed
set of 7 views under Company → Reports (see
[[navigation-me-team-company]], post-MVP
[[../projects/hris/features/basic-reporting/PLAN.md|basic-reporting]])
— over "Report Rail, Grouped" (a persistent left sidebar) and "Pill
Tabs, All-in-One" (a flat row of 7 pills above the table). All three
built the same 7 reports on identical tokens; only the navigation
shell around switching between them differs. Full comparison:
https://claude.ai/code/artifact/dd3e83b7-5f8a-4427-8e47-061619bcc64c

**Layout:**
- Landing (default view): 7 report cards in two labeled groups —
  People & Leave (Headcount Snapshot, New Hires vs. Departures,
  Turnover Count, Leave Balances, Leave Taken Summary) and Payroll
  (Payroll Register, Statutory Contributions Summary) — each card an
  icon, the report's name, and a one-line plain-language description
  of what it answers.
- Detail (drill-in): a "← Back to Reports" link, the report's title +
  description, a filter toolbar, the data table, and an Export CSV
  button. Every report's filter shape matches what's actually
  filterable rather than a one-size-fits-all bar: point-in-time
  reports (Headcount Snapshot, Leave Balances) get an "As of" date
  instead of a range; Payroll Register gets a Cutoff select; Statutory
  Contributions Summary gets a Period select with no department filter
  since it's company-wide.
- Turnover Count shows a raw per-department count only — no computed
  rate, per basic-reporting's explicit out-of-scope note.

Built on tokens already decided elsewhere:
[[color-palette-ink-and-amber|Ink & Amber]] palette,
[[type-system-neutral-and-efficient|Archivo/Work Sans/IBM Plex Mono]]
type, and [[data-tables-comfortable-density|comfortable table
density]] with zebra striping on the two employee-level tables
(Leave Balances, Payroll Register) where several columns sit side by
side.

**Carried over, not re-decided here:** Company tab is HR-Admin-only,
absent (not filtered) for anyone else, per
[[navigation-me-team-company]]. Reuses the same 11-person, 5-department
roster (Engineering, Design, Finance, Sales, People) as
[[people-directory-card-grid-with-list-toggle|People Directory]] and
[[company-reviews-roster-filterable-grid-list|Company Reviews]] so
Reports reads as the same real company rather than fresh data. Fixed
set of exactly 7 views, no report builder, no charts, no scheduled/
emailed reports — a table is the whole v1, per
[[../projects/hris/features/basic-reporting/PLAN.md]].

Why this one: each card's one-line description answers "which of
these do I even want" up front — "Turnover Count" vs. "Leave Taken
Summary" aren't fully self-explanatory names on their own, and this
persona isn't necessarily coming from a data background. The Report
Rail option was the closer runner-up on pure efficiency (every report
one click away, no re-navigation for someone who already knows what
they want) and stays the better fit if Reports turns out to be opened
several times a day on the same 2–3 views — worth revisiting if that's
how it plays out in practice, but the landing grid's teaching value was
judged more valuable up front for a fixed set HR is still learning.

HTML mockup: [[../ux-pages/reports.html]]
