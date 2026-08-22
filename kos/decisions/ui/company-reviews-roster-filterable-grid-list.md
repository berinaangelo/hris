---
title: company-reviews-roster-filterable-grid-list
tags: [hris, design, ux, company, admin, reviews]
date: 2026-08-22
---

Chose "Company roster, filterable" for the v1 Company Reviews page —
the HR-Admin workspace under Company → Performance Reviews (see
[[navigation-me-team-company]]) — the company-wide counterpart to a
manager's own [[team-reviews-split-editable-detail|Team Reviews]] —
over "Departments, rolled up" (accordion per department with a
completion progress bar) and "Cycles, first" (review cycles themselves
as the primary list, rostered on expand). Full comparison, all three
built on the same tokens:
https://claude.ai/code/artifact/39489da0-c99f-4620-ba80-9d064e9bda80

**Layout:**
- A flat, searchable roster of all 10 employees across every
  department, filterable by department and by status chip
  ("On PIP", "Needs scoring") — the same toolbar/chip-filter shape as
  [[people-directory-card-grid-with-list-toggle|People Directory]].
- A card/list view toggle, same mechanism and `.person-card` shape as
  People Directory's — list is the default here (this page started life
  as a table, unlike People Directory where card was the default), card
  is the alternate.
- A static, illustrative pagination bar under both views (`Showing
  1–10 of 10`, Prev/Next present but disabled at this headcount) —
  added for the shape now so a real page-size limit isn't a surprise
  once headcount grows past one screen.
- Clicking a row or card opens a read-only detail (KPI table for a
  closed cycle, a status note for an open one) — reviews stay
  manager-authored per
  [[performance-review-kpi-based-not-form-builder]]; HR views, HR
  doesn't score.
- "Start new cycle" opens company-wide/department/individual in scope,
  cycle type (Regular/PIP), and period — the actual cycle-open action
  from [[performance-review-kpi-based-not-form-builder]]'s core flow.

Built on tokens already decided elsewhere:
[[color-palette-ink-and-amber|Ink & Amber]] palette,
[[type-system-neutral-and-efficient|Archivo/Work Sans/IBM Plex Mono]]
type, [[badge-system-four-categories|four-category badges]] — "On PIP"
shown as Negative here rather than Team Reviews' page-scoped Caution,
since read company-wide across every department, an active PIP is
exactly the deviation that badge category exists to flag.

**Carried over, not re-decided here:** roster, titles, departments, and
manager relationships mirror
[[people-directory-card-grid-with-list-toggle|People Directory]]
exactly — Ramon Dela Cruz (Engineering Manager) over Mikaela Santos,
Paolo Villanueva, Carlo Bautista, Diego Reyes, and Grace Lim (Design);
Ferdinand Ocampo (Finance Manager) over Isabel Torres (Accountant);
Miguel Santos (Sales Lead) over Bea Fernandez (Sales Associate).
Offboarded employees (Jonas Rivera) are excluded from the review
roster entirely — reviews don't apply post-offboarding. Ahead of the
backlog on purpose: performance reviews/goals is still post-MVP
backlog, not committed to a version (see
[[../projects/hris/features/performance-reviews-goals/PLAN.md]]).

Why this one: closest to the familiar admin-list shape HR already
knows from People Directory, and the fastest path to one specific
person or one specific status ("show me everyone on PIP") — the two
things an HR admin actually reaches for between the twice-yearly cycle
opens. Departments, Rolled Up gave the best at-a-glance read on which
manager is falling behind, and Cycles, First matched the underlying
data model most directly (see that option's own reasoning in the
mockup) — both stayed on the table as strong alternatives, but neither
beats a flat searchable roster for the more common day-to-day task of
finding a person, and the department/status chips already answer the
"who's behind" question the rolled-up option was built for.

HTML mockup: [[../ux-pages/company-reviews.html]]
