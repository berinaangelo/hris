---
title: job-opening-form-right-side-drawer
tags: [hris, design, ux, company, admin, recruitment]
date: 2026-08-22
---

Chose "Right-side drawer" for the Add/Edit Job Opening form — what "New
job opening" on [[job-openings-card-grid-with-list-toggle|Job Openings]]
and "Edit opening" on
[[job-opening-detail-kanban-stage-columns|Job Opening Detail]] both open
(Company → Recruitment → Job Openings,
[[../projects/hris/features/recruitment-ats/PLAN.md]]) — over "Centered
modal" and "Inline edit-in-grid". Full comparison, shown as the Edit case
(Senior Backend Engineer, prefilled) since Create is the identical layout
with empty fields:
https://claude.ai/code/artifact/9c0e11dc-87a5-48dc-93e9-37aa65ecf121

**Layout — the chosen option:**
- Opens a right-side slide-over drawer over the dimmed Job Openings grid —
  the 6th reuse of the same drawer mechanic already used for Payroll Run
  Detail, Time & Attendance, Rate Tables, Loan Ledger, and Hired Handoff.
- Posting details section: job title and description, both plain editable
  fields.
- Status section: Open/Closed toggle pills.
- Application link section: the auto-generated apply link
  (hris.app/apply/…), shown read-only — not user-editable, since it's
  derived from the title.
- Preview section: a compact live preview of the actual card HR will see
  on Job Openings, same "show the real result before commit" reasoning as
  Add Employee's directory-card preview.
- Footer: Cancel / "Create job opening" (or "Save changes" in Edit mode).

Built on tokens already decided elsewhere:
[[color-palette-ink-and-amber|Ink & Amber]] palette,
[[type-system-neutral-and-efficient|Archivo/Work Sans/IBM Plex Mono]] type,
[[badge-system-four-categories|four-category badges]], and the same
drawer/field/plain-input classes as
[[rate-tables-landing-cards-edit-drawer|Rate Tables]],
[[loan-ledger-flat-table-edit-drawer|Loan Ledger]], and
[[hired-handoff-review-and-edit-drawer|Hired Handoff]].

**Carried over, not re-decided here — field scope:** per the plan's own
in-scope list this form only ever captures title, description, and
open/closed status — no department, location, or employment-type fields
invented beyond what's scoped. The apply link is illustrative
(hris.app/apply/…), no real subdomain wired.

Why this one: this form has two entry points — "New job opening" from the
Job Openings grid, and "Edit opening" from Job Opening Detail's kanban
header — and only an overlay travels cleanly to both. "Inline edit-in-grid"
was the more distinctive option (zero extra chrome, edits happen exactly
where the card lives) but only works from the grid; Job Opening Detail has
no grid to edit inline, so that entry point would need a second, different
mechanic anyway, teaching HR two ways to edit the same record depending on
which page they're on — and it would also need its own layout for the
card/list view toggle already chosen on Job Openings. Between the two
overlays, "Centered modal" is the lighter build for three fields and would
have been a reasonable pick on its own, but the drawer is already the
established pattern for every other admin edit surface in this project, so
reusing it costs nothing and keeps the interaction consistent — plus it has
room for the live card preview and apply-link preview that a modal would
cramp.

HTML mockup: [[../ux-pages/job-opening-form.html]]
