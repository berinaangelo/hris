---
title: offboarding-flow-schedule-clearance-tracker
tags: [hris, design, ux, company, people]
date: 2026-08-23
---

Chose "Schedule + persistent clearance tracker" for the Offboarding
Flow — what "Offboard" opens on
[[employee-detail-inline-edit-with-reserved-tabs|Employee Detail]],
shown there as an entry point only with no flow behind it. Not on the
original build list ([[../../hris-remaining-pages-roadmap|the
roadmap]]) — requested ad hoc, same as
[[org-chart-classic-top-down-tree|Org Chart]]. Over "Quick drawer,
instant status flip" (one form, confirm sets Offboarded immediately)
and "Modal, gated clearance checklist" (single-sitting modal, confirm
disabled until four clearance boxes are ticked). Full comparison, all
three built on the same tokens:
https://claude.ai/code/artifact/bdfd670c-c5a3-4624-9ade-925897336d57

**Layout — the chosen flow, two stages:**
- Clicking "Offboard" opens a right-side drawer (8th reuse of the
  mechanic already shipped for Payroll Run Detail, Time & Attendance,
  Rate Tables, Loan Ledger, Hired Handoff, and the Job Opening form) —
  last working day, reason for separation, rehire-eligible checkbox,
  notes. Confirming it only *schedules* the separation: status flips
  to the new "Offboarding" badge (Caution), and a "Separation" section
  appears on the page.
- The Separation section mirrors the Onboarding checklist already on
  this page, run in reverse: a summary strip (last working day, days
  remaining), four independently markable clearance rows (equipment
  returned, system access revoked, final pay & clearance computed,
  exit interview completed), and a "Mark offboarded" button that stays
  disabled until the last day has passed and every row is done.
- Confirming "Mark offboarded" flips status to the terminal
  "Offboarded" badge (Neutral) — the same badge already shown on Jonas
  Rivera's [[people-directory-card-grid-with-list-toggle|People
  Directory]] card, which this flow is the origin story for — and
  collapses the Separation section into a locked one-line summary.

**New badge status, defined alongside this decision:**
[[badge-system-four-categories]] now lists Employee status → Offboarding
(Caution, in progress) → Offboarded (Neutral, terminal), added
specifically for this flow rather than left implicit.

**Scope note, resolved 2026-08-23:** People Directory's status
display/filter now recognizes "Offboarding" too —
[[people-directory-card-grid-with-list-toggle|People Directory]] was
updated the same day: Jonas Rivera shows the Offboarding badge inline,
visible by default (he's still working), while the "Show offboarded"
toggle keeps hiding only the terminal Offboarded state, demonstrated
with a second example, Kristine Aquino. See that page's own mockup for
the exact treatment.

Built on tokens already decided elsewhere:
[[color-palette-ink-and-amber|Ink & Amber]] palette,
[[type-system-neutral-and-efficient|Archivo/Work Sans/IBM Plex Mono]]
type, [[badge-system-four-categories|four-category badges]], and the
same identity-strip/section/checklist-row components already built for
[[employee-detail-inline-edit-with-reserved-tabs|Employee Detail]].

**Carried over, not re-decided here:** reason for separation, last
working day, and the four-item clearance checklist are this flow's own
invented scope — no PLAN.md names them. Content uses Jonas Rivera
(EMP-0089), already shown Offboarded on People Directory, rather than
Mikaela Santos (used elsewhere as the running active-employee example)
to avoid implying she's being separated in other decided mockups.

Why this one: the other two options set "Offboarded" the moment HR
clicks confirm, which is only true if the separation is immediate — a
last working day genuinely in the future (the common case; two weeks'
notice is standard) means the record would call someone Offboarded
weeks before they're actually gone, with equipment/access/final-pay
clearance unmodeled anywhere. This option's two-stage shape — a
transitional "Offboarding" status plus a tracked checklist gating the
terminal state — keeps the record honest at every point instead of
only at the end, and reuses a component (the reversed Onboarding
checklist) already on this exact page rather than inventing a new one.
The cost is real: it's the only option that touches the badge system —
People Directory needed a follow-up pass to recognize the new status,
done the same day (see above), not silently left inconsistent.

HTML mockup: [[../ux-pages/offboarding-flow.html]]
