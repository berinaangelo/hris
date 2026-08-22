---
title: hired-handoff-review-and-edit-drawer
tags: [hris, design, ux, company, admin, recruitment]
date: 2026-08-22
---

Chose "Review-and-edit drawer" for the "Hired" handoff — what happens the
instant HR clicks "Mark Hired" on an Offer-stage candidate in
[[job-opening-detail-kanban-stage-columns|Job Opening Detail]] (Company →
Recruitment → Job Openings → an opening,
[[../projects/hris/features/recruitment-ats/PLAN.md]]) — over "Lightweight
confirm modal" and "Redirect into Add Employee, prefilled". This step was
explicitly left unscoped when the kanban pipeline layout was decided
("assumed to be a lightweight confirm dialog, not modeled") — this doc
closes that gap. Full comparison, same opening (Senior Backend Engineer)
and candidate (Ramil Espino, offer accepted):
https://claude.ai/code/artifact/6c8072d7-cf32-433c-a2b6-4bd50d13c82f

**Layout — the chosen option:**
- Clicking "Mark Hired" opens a right-side slide-over drawer over the
  dimmed kanban board — the same drawer mechanic already reused across
  Payroll Run Detail, Rate Tables, and Loan Ledger (4th reuse).
- Identity & Contact section: full legal name and personal email, both
  read-only and tagged "From application" — no retyping the plan's own
  payoff moment depends on.
- Org Position section, editable: job title (defaults from the opening
  itself, "Senior Backend Engineer"), department (blank, HR types it),
  manager (optional select), start date (defaults from the offer), and
  employment type (select, defaults to Probationary).
- Résumé shown as a file row tagged "From application" — carried over,
  not re-uploaded.
- Footer: Cancel / "Create employee record" — creating the record is what
  closes the drawer and moves the candidate card to the Hired column.

Built on tokens already decided elsewhere:
[[color-palette-ink-and-amber|Ink & Amber]] palette,
[[type-system-neutral-and-efficient|Archivo/Work Sans/IBM Plex Mono]] type,
[[badge-system-four-categories|four-category badges]], and the same
drawer/field-grid/plain-input classes as
[[rate-tables-landing-cards-edit-drawer|Rate Tables]] and
[[loan-ledger-flat-table-edit-drawer|Loan Ledger]].

**Carried over, not re-decided here:** résumé links and the public
application link stay illustrative, no real file storage wired. The
underlying kanban board layout is
[[job-opening-detail-kanban-stage-columns|already decided]] — this doc
only fills in what "Mark Hired" actually opens. Manager list and
employment-type options reuse
[[add-employee-split-live-preview|Add Employee]]'s own field set verbatim,
since this drawer is creating the same employee record through a different
entry point.

Why this one: the application form only ever captures name, email, phone,
résumé, and a note — none of the org facts (department, manager,
employment type) the employee record actually needs, so *something* has to
collect them at Hired time regardless of how light the confirmation itself
is. The drawer finishes that setup in the same motion as confirming Hired,
without leaving the pipeline board — picked over the confirm modal (fastest
to click, but defers department/manager/type to a mandatory follow-up trip
to Employee Detail before the hire routes approvals correctly) and over
redirecting into the full Add Employee page (zero new pattern, matches Add
Employee's own "show the result before commit" reasoning, but a full page
navigation away from the pipeline is more ceremony than a status change on
an already-decided hire needs). The drawer mechanic being a 4th reuse
elsewhere also meant no new interaction pattern had to be invented for
this either.

HTML mockup: [[../ux-pages/hired-handoff.html]]
