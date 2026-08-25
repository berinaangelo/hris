---
title: attendance-edit-signoffs-queue-cards
tags: [hris, design, ux, attendance, company]
date: 2026-08-25
---

Chose "Queue Cards" for the Attendance Edit Sign-offs inbox — the
admin-only oversight screen under Company → Attendance Sign-offs (see
[[navigation-me-team-company]]) where a manager-made manual attendance
edit gets approved or rejected — over "Flat Table + Inline Actions"
(properly styled but otherwise the page's existing bare-table shape)
and "Split List + Detail Drawer" (click a row to review full context
before deciding). Full comparison, all three built on the same tokens:
https://claude.ai/code/artifact/c7540222-1d60-4826-930d-b1f7504ef56f

This page's screen was never designed in the first place — the feature
itself (model, interactors, policies, mailer/job, controller, routes,
tests) shipped fully wired per
[[../time-attendance-correction-request-and-manual-edit|the manual-edit
decision]], which explicitly noted "the Attendance Sign-offs inbox page
... was deliberately not mocked in this pass." This closes that gap.

**Layout:**
- 2nd reuse of [[team-approvals-inbox-inline-actions|Team Approvals]]'
  own `queue-live`/`req-item` mechanic — the closest sibling shape
  already in the app (single-level admin reviewing a small pending
  queue). One card per pending edit: employee, job title, who edited it
  and when, the edited clock in/out times.
- Approve stays one click (`AttendanceEditApproval::ApproveEdit`, no
  irreversible payroll effect either way). Reject opens the shared
  right-side drawer for a confirm step — same mechanic Team Approvals
  uses for its own Reject, but without a decision-note field, since
  `AttendanceEditApproval::RejectEdit` doesn't take one; not invented
  here.
- A "Recently decided" table below the live queue shows already-decided
  edits with their positive/negative status badges, reusing the
  existing global `.dectable` styling — no new table CSS needed.
- Guided empty state ("You're all caught up," no CTA) covers the
  zero-pending case, reusing the app's existing shared `.empty-state`
  component per [[empty-states-guided]].

Built on tokens already decided elsewhere:
[[color-palette-ink-and-amber|Ink & Amber]] palette,
[[type-system-neutral-and-efficient|Archivo/Work Sans/IBM Plex Mono]]
type, [[badge-system-four-categories|four-category badges]], and the
drawer mechanic first established for Time & Attendance's own Shift
Templates/Edit/Review drawers.

**Carried over, not re-decided here:** admin-only sign-off, no manager
branch; oversight-only, never gates payroll or reverts the underlying
punch; single optional approver, no chain — all per the manual-edit
decision doc.

Why this one: mirrors the app's own closest precedent for "an admin
works through a small pending queue" rather than either reinventing the
shape (Option 1 stays closest to today's bare table, but leaves Reject
a single click with no confirm on a decision that has no undo) or
introducing a heavier click-through pattern the actual queue size
doesn't need yet (Option 3's per-row drawer earns its keep once the
queue can't stay comfortable as one screen of cards, which isn't the
case for a Philippine SME's admin reviewing a handful of manager edits
at a time). Reusing Team Approvals' exact mechanic also means nothing
new to learn for the same admin who already triages leave requests
there.

HTML mockup: [[../ux-pages/attendance-edit-signoffs.html]]

Real build: `app/views/team/attendance_edit_approvals/index.html.erb`,
`.attendance-edit-approvals-page` in `application.scss`.
