---
title: my-reviews-split-master-detail
tags: [hris, design, ux, reviews]
date: 2026-08-21
---

Chose "Split, Master-Detail" for the v1 My Reviews page — the
employee's read-only view of their own review cycles, under Me → My
Reviews (see [[navigation-me-team-company]]) — a persistent cycle rail
beside a detail panel that switches on selection, over "List + Modal
Detail" (a scannable list with a modal for full KPI detail) and
"Timeline / Accordion" (one scrollable history, cards expand in place).
Full comparison, all three built on the same tokens:
https://claude.ai/code/artifact/ad0ce4a7-fd3f-488d-b35b-727f5165d8d2

**Layout:**
- Left rail (narrow, fixed): every cycle on file, most recent first —
  period, type, and either the overall rating or an "In progress"
  badge. The current in-progress cycle sits at the top, so its state is
  visible without opening anything.
- Right panel: the selected cycle's overall rating, full KPI table
  (`kpi_name` / `target` / `actual` / `score`), and the manager's
  comment — or, for the in-progress cycle, a plain status note instead
  of scores.
- No modal, no accordion state — switching cycles is one click, and the
  rail never disappears.

Built on tokens already decided elsewhere:
[[color-palette-ink-and-amber|Ink & Amber]] palette,
[[type-system-neutral-and-efficient|Archivo/Work Sans/IBM Plex Mono]]
type, [[badge-system-four-categories|four-category badges]] (used only
for the non-default "In progress" state — a published cycle's rating is
shown as plain text, no badge, per the badge decision's "omitted for
default/steady states" rule), and the fixed KPI structure from
[[performance-review-kpi-based-not-form-builder]].

**Carried over, not re-decided here:** this page is designed ahead of
the feature's own commitment — performance reviews/goals is still
post-MVP backlog (see
[[../../projects/hris/features/performance-reviews-goals/PLAN.md]]),
built now because [[navigation-me-team-company]] already reserves the
nav slot. An "On PIP" badge would appear in the rail next to an active
PIP-type cycle; not shown here since this persona isn't on one.

Why this one: an employee reviewing their own history is the closest
this page gets to "who's out this week is answerable by looking, not
asking" — comparing a current cycle against a past one, or just
rereading an old comment, shouldn't cost an open/close/open round trip
through a modal. Keeping the rail always visible also means the
in-progress cycle's status is ambient, not something someone has to
click into a list row to discover.

List + Modal Detail was the cheaper build — it reuses the exact modal
already shipped for My Profile and Time Off, no new component. Set
aside because reviews are the one place in v1 where someone plausibly
wants two cycles open in quick succession (this half vs. last half),
and a modal makes that an open/close/open loop. Timeline / Accordion
solved the narrow-screen case better and also needed no modal, but
loses the fixed rail's guarantee that nothing ever re-flows the page —
fine at two cycles a year, but the first design to break if review
cadence ever changed.

HTML mockup: [[../ux-pages/my-reviews.html]]
