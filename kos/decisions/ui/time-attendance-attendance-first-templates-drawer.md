---
title: time-attendance-attendance-first-templates-drawer
tags: [hris, design, ux, company, admin, time-attendance]
date: 2026-08-22
---

Chose "Attendance-first + Templates Drawer" for Time & Attendance — the
HR-Admin-only screen under Company → Time & Attendance (see
[[navigation-me-team-company]], post-MVP, customer-dependent
[[../projects/hris/features/time-attendance/PLAN.md|time-attendance]]) —
over a "Stacked Sections" option (both pieces always visible, one
scroll) and a "Segmented Switch" option (a Shift Templates / Attendance
Records pill toggle). Full comparison, same 3 shift templates and 10
employees on identical tokens:
https://claude.ai/code/artifact/ce6d71de-788d-401c-971a-4bd66178cb72

**Layout — the chosen option:**
- Attendance Records is the whole page: period selector (Today / This
  week / This period), a stat strip (On time / Late / Undertime /
  Absent counts), search + status filter chips, then the flat table —
  Employee, Shift, Clock in, Clock out, Status.
- Shift Templates lives behind a "Manage shift templates" button that
  opens a right-side slide-over drawer — a compact card per template
  (name, hours, assigned-employee count, edit) plus an "Add shift
  template" action at the bottom. Shown open in the mockup for review;
  closed by default in the real screen.
- Each attendance row carries a small Shift tag (e.g. "Dayshift") so
  the template→employee relationship stays visible on the primary
  table without ever opening the drawer.
- Status column carries a badge only for Late/Undertime (Caution) or
  Absent (Negative); On time shows no badge, per
  [[badge-system-four-categories]]'s "badges are for deviation" rule.

Built on tokens already decided elsewhere:
[[color-palette-ink-and-amber|Ink & Amber]] palette,
[[type-system-neutral-and-efficient|Archivo/Work Sans/IBM Plex Mono]]
type, and [[data-tables-comfortable-density|comfortable table
density]].

**Carried over, not re-decided here:** shift templates stay a short
editable list (`name`, `start_time`, `end_time`) — no rotating
schedules, per-day overrides, or shift-swap workflow; attendance
records are a simple digital/manual punch, not a biometric or
geolocation-validated clock; late/undertime is a comparison against
the assigned shift, not a pay computation — no auto-feed into payroll
OT/deductions and no night-differential/holiday-pay premiums — all per
[[../projects/hris/features/time-attendance/PLAN.md]]. No row detail
or edit modal wired in the mockup; the drawer's inputs are illustrative,
not functional.

Why this one: matches the plan's own description of who uses which
piece and how often — HR "sees a daily/period attendance list," while
shift templates are described as a short list HR "adds/edits
directly," implying occasional maintenance rather than a screen worth
permanent page-top real estate. Putting attendance in full, unshared
width keeps the screen's primary job — spotting who's late, short, or
absent today — a zero-scroll glance, which is the same "god moments"
reasoning behind [[compliance-certifications-pinned-attention-full-list|Compliance's
pinned-attention layout]]. The Stacked option gave both pieces equal
weight despite very different usage frequency; the Segmented option
buried Attendance behind a click on load and made the two views
mutually exclusive even though a template's assigned-count is really a
summary of the same attendance data. The drawer keeps that link
visible via the per-row Shift tag while still being reachable in one
click for the rarer edit-a-template task. Cost: the drawer overlays the
table rather than sitting beside it, so cross-checking a specific
attendance row while editing a template means opening and closing it;
on a narrow viewport it would also cover most of the table underneath
— acceptable since template edits are infrequent and desktop is the
expected admin context.

HTML mockup: [[../ux-pages/time-attendance.html]]
