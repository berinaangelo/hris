---
title: home-dashboard-attendance-clock-in-out-disabled
tags: [hris, design, ux, home, dashboard, time-attendance]
date: 2026-08-23
---

Added an **Attendance** card (Clock in / Clock out) to the
[[home-dashboard-balance-led-hero|Home dashboard]] — the self-service half
of [[../projects/hris/features/time-attendance/PLAN.md|Time & Attendance]]
that [[time-attendance-attendance-first-templates-drawer|the existing Time
& Attendance screen]] doesn't cover (that screen is HR-Admin only:
Attendance Records + Shift Templates). Home was chosen as the placement per
the plan's own flow — "Employee clocks in/out each day" — over a new
standalone Me-tab page, matching the same landing-screen-for-
highest-frequency-action reasoning already used for leave balance in the
hero. Requested directly by the user, no three-option comparison (standing
pattern as of 2026-08-23).

**Disabled on purpose:** Clock in and Clock out are both real `<button
disabled>` elements, not live actions — self-service time tracking still
needs to be designed properly, but the user was explicit the feature
itself is committed ("for sure clock-in and out should be present in this
project"), unlike [[payroll-settings-parked-overtime-deduction-defaults|the
Payroll Settings additionals]] which are parked pending an uncertain scope
decision. Framed as "still being built," not "maybe later."

**Styling:** both buttons use `.btn-ghost` (bordered, neutral), not
`.btn-primary` (amber) — keeps the hero's "Request time off" the only
amber CTA on the screen, per
[[home-dashboard-balance-led-hero]]'s own one-accent-one-job reasoning.
`:disabled` gets reduced opacity, `cursor: not-allowed`, no hover/pointer
events. A small lock icon (Lucide) next to the "Attendance" card-label
signals not-yet-interactive, same visual language as
[[payroll-settings-parked-overtime-deduction-defaults]]'s locked cards.

**Placement per layout** — added identically across all three tabs of the
home-dashboard comparison mockup (page context, not re-opening that
decision):
- Stat row + list (Option 1): 4th card in the stat grid, after "My
  requests" — literally the extensibility the option's own rationale text
  already named ("room to add a fourth card later").
- Balance-led hero (Option 2, chosen): new card in the aside stack, after
  "At a glance," before the manager-only approvals nudge.
- Compact feed (Option 3): a new `.attendance-strip`, same visual weight
  as the existing balance-strip, placed directly below it.

**Not decided here, left open:** what "self-service time tracking" actually
looks like once built — a real punch flow, confirmation state, today's
clocked hours, whether it writes into the existing Attendance Records
table HR sees. This only reserves the card's presence and disabled state.

HTML mockup: [[../ux-pages/home-dashboard.html]]
