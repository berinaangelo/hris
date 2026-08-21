---
title: team-calendar-week-agenda
tags: [hris, design, ux, team, calendar]
date: 2026-08-21
---

Chose "Week Agenda" for the v1 Team Calendar — the manager-only view
under Team → Team Calendar (see [[navigation-me-team-company]]) — a
plain day-by-day list for the current week — over "Month Grid" (a
spatial calendar with absence chips per day) and "Team Row Timeline" (a
Gantt-style swimlane, one row per person against a date axis). Full
comparison, all three built on the same tokens:
https://claude.ai/code/artifact/b925b714-fd14-449c-9ab7-2729909581ce

**Layout:**
- One row per day, Monday through Sunday of the current week: a date
  column, and a list of whoever's out that day (name, leave type,
  Approved/Pending status). A day with nobody out says so plainly ("No
  one out") rather than leaving blank space.
- Prev/next arrows move the whole view a week at a time.
- Read-only over existing time-off request data — no new data model.
  Approved requests appear at full weight; Pending appear tinted as
  tentative; Rejected never appears, since that employee isn't actually
  out. Same color language as
  [[badge-system-four-categories|the badge system]].

Built on tokens already decided elsewhere:
[[color-palette-ink-and-amber|Ink & Amber]] palette,
[[type-system-neutral-and-efficient|Archivo/Work Sans/IBM Plex Mono]]
type, and [[badge-system-four-categories|four-category badge colors]]
reused for the Approved/Pending status language.

**Carried over, not re-decided here:** scoped to the viewing manager's
own direct reports, same team as
[[team-approvals-inbox-inline-actions]]. Shift schedules and attendance
stay out of scope — that's the separate, still-backlog Time &
Attendance feature.

Why this one: the v1 plan's god moment for this screen is worded as
"who's out this week is answerable by looking, not asking" — Week
Agenda is the most literal build of that exact sentence, with nothing
to parse beyond scrolling a handful of days. It's also the lightest of
the three to build: no date-axis grid math, no spanning-bar
positioning, just a list — and it's the one most at home on a phone,
which matters for a manager checking this between other things rather
than sitting down to plan.

Month Grid put the whole month on screen at once with no navigation,
which is a real advantage for looking ahead — Mikaela's late-August
vacation is visible immediately there, but costs a full week-by-week
page-forward here. Set aside because "this week" is the actual
question this screen exists to answer per the plan's own wording; a
month view answers a different, less common question. Team Row
Timeline was the best tool for a genuinely different job — checking
coverage overlap across the whole team — but that's closer to what
Team Approvals' inline balance-and-headcount context already covers
case by case; a dedicated swimlane felt like solving a problem this
product hasn't shown it has yet.

HTML mockup: [[../ux-pages/team-calendar.html]]
