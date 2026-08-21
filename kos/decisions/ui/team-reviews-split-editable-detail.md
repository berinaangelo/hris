---
title: team-reviews-split-editable-detail
tags: [hris, design, ux, reviews, team]
date: 2026-08-21
---

Chose "Split, Editable Detail" for the v1 Team Reviews page — the
manager-only workspace under Team → Team Reviews (see
[[navigation-me-team-company]]) — a persistent roster rail beside a
detail panel that switches on selection, with actual/score/comment
fields editable in place — over "Roster Table, Row Actions" (a flat
table with row actions opening a shared modal) and "Card Grid, Status
First" (a photo-forward card grid, same shared modal). Full comparison,
all three built on the same tokens:
https://claude.ai/code/artifact/d8722272-0492-4f88-b427-4e18dd5e6aab

**Layout:**
- Left rail (narrow, fixed): every direct report, with a status badge
  or last rating as secondary context — mirrors the rail pattern
  already chosen for [[my-reviews-split-master-detail|My Reviews]], one
  click to switch, rail never disappears.
- Right panel: content depends on the selected report's cycle state —
  a published cycle shows the read-only rating/KPI table/comment (same
  components as My Reviews); a cycle awaiting scoring shows the KPI
  table with `actual` and `score` editable in place plus an overall
  comment field, with Save Draft / Publish Review actions; a
  not-started report shows a short draft-KPI form to open the next
  cycle; an in-progress or on-PIP cycle shows a status note and the KPI
  targets, read-only until the cycle ends.
- Where a report has both a finished cycle and no next cycle open yet,
  both appear in the same panel — the finished review's detail sits
  directly above the draft form for the next one, no modal hand-off
  between reviewing the past and acting on what's next.

Built on tokens already decided elsewhere:
[[color-palette-ink-and-amber|Ink & Amber]] palette,
[[type-system-neutral-and-efficient|Archivo/Work Sans/IBM Plex Mono]]
type, [[badge-system-four-categories|four-category badges]] ("On PIP"
and "In progress" both Caution, per the badge decision's own mapping),
and the fixed KPI structure from
[[performance-review-kpi-based-not-form-builder]]. The editable score
field pairs a plain `<select>` (1–5) with a small track/fill bar
matching the read-only score display used elsewhere, rather than a
range-slider input — kept for precision on a phone and consistency with
every other field on the page, which are all plain form controls per
[[form-validation-inline-only]].

**Carried over, not re-decided here:** this page is designed ahead of
the feature's own commitment — performance reviews/goals is still
post-MVP backlog (see
[[../../projects/hris/features/performance-reviews-goals/PLAN.md]]),
built now because [[navigation-me-team-company]] already reserves the
nav slot. Same 5-person team as
[[team-approvals-inbox-inline-actions]] and
[[team-calendar-week-agenda]]. PIP outcome (Passed/Not Passed/Extended)
is recorded at cycle close — not shown active here since no PIP closes
in this persona set.

Why this one: unlike [[my-reviews-split-master-detail|My Reviews]],
which is read-only for the employee, this page is where a manager does
the actual work — opening a cycle, setting KPIs, and filling in
actual/score/comment at cycle end (see
[[performance-review-kpi-based-not-form-builder]]'s core flow). That
work needs room for several fields at once, which a fixed-width modal
constrains and a full-width detail panel doesn't. It also means a
manager reviewing someone's history while writing their next cycle's
KPIs never leaves the page — the god-moments principle ("the right fact
is already visible, with zero setup or asking around") applied to the
act of writing a review, not just checking its status.

Roster Table, Row Actions was the faster build for pure status-triage —
closest to the winning pattern in
[[team-approvals-inbox-inline-actions]] — but set aside because the
actual scoring work still happens in a cramped modal, and Team Reviews'
core job is that work, not the triage. Card Grid, Status First gave the
most glanceable team-wide overview, best for a manager who just wants a
monthly check rather than to do the writing right now, but falls back
to the same modal as Option 1 for any real work — set aside for the
same reason.

HTML mockup: [[../ux-pages/team-reviews.html]]
