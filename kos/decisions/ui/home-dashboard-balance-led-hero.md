---
title: home-dashboard-balance-led-hero
tags: [hris, design, ux, home, dashboard]
date: 2026-08-21
---

Chose "Balance-Led Hero" for the HRIS Home dashboard — the "Me" tab's
landing screen (see [[navigation-me-team-company]]) — a full-width navy
hero block leading with leave balance, over "Stat Row + List" (balance
and pending-count shown as equal-weight cards) and "Compact Feed" (a
narrow single column, balance shown as a slim strip, requests as a
feed). Full comparison, all three built on the same tokens, with an
Employee/Manager toggle to preview the nav badge count:
https://claude.ai/code/artifact/32a82f45-4044-4a03-ba15-2d23f5727dd8

**Layout:**
- Top: shared app nav (Me / Team), ink background — Team tab and its
  caution-colored count pill only exist for managers, per the
  absent-not-filtered rule in [[navigation-me-team-company]] and the
  live-count mechanism in [[notifications-nav-badge-counts]].
- Greeting line: name + "You report to {manager} · {department}" —
  the profile/manager/team-already-correct god moment, made concrete
  instead of left implicit.
- Hero: full-width navy block, large IBM Plex Mono balance figure
  ("12.5 days remaining"), a thin usage meter, and the one amber CTA
  on the screen ("Request time off").
- Below the hero: a two-column area — main column is "My requests"
  (comfortable-density rows per
  [[data-tables-comfortable-density|table density]], status badges per
  [[badge-system-four-categories|the badge system]]); aside column is a
  small "At a glance" pending-count card, plus (manager-only) a caution
  card nudging toward Team → Approvals.

Built on tokens already decided elsewhere:
[[color-palette-ink-and-amber|Ink & Amber]] palette,
[[type-system-neutral-and-efficient|Archivo/Work Sans/IBM Plex Mono]]
type, [[badge-system-four-categories|four-category badges]],
[[data-tables-comfortable-density|comfortable table density]],
[[notifications-nav-badge-counts|nav badge counts]], and
[[empty-states-guided|guided empty states]] for the no-pending-requests
case this layout would show if the aside/list were empty.

**Not yet a decision, carried over as an open assumption:** the leave
balance figures shown (12.5 of 15 days) are placeholder content — there
is no entitlement/accrual policy on file yet, only that a real balance
must be visible per the v1 [[../projects/hris/PLAN.md|PLAN]]'s god
moments.

Why this one: the v1 plan names "employee sees their real balance
before submitting a leave request" as one of the system's specific god
moments — this layout spends real visual weight making that one fact
unmissable, the same one-accent-one-job reasoning already used for
[[color-palette-ink-and-amber|the amber CTA color]]. Costs more than
Stat Row + List: a hero needs its own content decisions (a usage meter,
an accrual note) the plainer grid avoids, and pushes the requests list
below the fold on shorter screens. Compact Feed was set aside for the
opposite reason it might otherwise win — it's the better fit for a fast
mobile glance, but by design it treats balance as one row among several
rather than the thing that should be unmissable, which is exactly the
god moment this screen is meant to serve.

HTML mockup: [[../ux-pages/home-dashboard.html]]
