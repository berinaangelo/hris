---
title: team-approvals-inbox-inline-actions
tags: [hris, design, ux, approvals, team]
date: 2026-08-21
---

Chose "Inbox List, Inline Actions" for the v1 Team Approvals page — the
manager-only inbox under Team → Approvals (see
[[navigation-me-team-company]]) — a flat list of pending requests with
Approve/Reject buttons directly on each row — over "Card Feed, Expand to
Decide" (collapsed cards that reveal reason + actions only once
expanded) and "Split, Focused Queue" (a persistent queue rail beside one
full decision panel). Full comparison, all three built on the same
tokens: https://claude.ai/code/artifact/bd8c3f48-3eb3-4ac3-8e81-46c87d414397

**Layout:**
- Each pending row carries everything needed to decide: employee,
  leave type, dates/days, and the employee's real leave balance shown
  inline as a chip — flagged caution-colored when approving would leave
  very little balance remaining.
- Approve (amber, the page's one accent-colored action) and Reject
  (outlined in the existing `--danger` token, not a new solid color) sit
  directly on the row — no click-through, no modal.
- A guided empty state ("You're all caught up," no CTA) covers the
  zero-pending case, per [[empty-states-guided]].
- A "Recently decided" table below the live queue shows already-decided
  requests with their positive/negative badges, for context/audit
  without leaving the page.

Built on tokens already decided elsewhere:
[[color-palette-ink-and-amber|Ink & Amber]] palette,
[[type-system-neutral-and-efficient|Archivo/Work Sans/IBM Plex Mono]]
type, [[badge-system-four-categories|four-category badges]],
[[notifications-nav-badge-counts|the live Team-tab count pill]], and
[[data-tables-comfortable-density|comfortable table density]] for the
decided-requests table.

**Carried over, not re-decided here:** approval stays single-level only
— straight to the requester's manager, no chain — per
[[../approval-chains-scrapped-fallback-design]]. Whether a rejection
requires a note is still open; this option keeps reject a single click,
consistent with the fallback design's own "same approve/reject
mechanism, just run twice — no new state machinery" framing.

Why this one: the v1 plan's own wording for this step is close to a
literal spec — "manager approves from one inbox with balance shown
inline... in one click" — and this is the only option of the three that
delivers zero steps between seeing a request and deciding it. The
caution-colored balance chip already surfaces the one real risk (an
approval that leaves someone nearly out of leave) without taxing every
decision with a mandatory extra step, so most of Card Feed's safety
benefit comes along without its added friction.

Card Feed's read-before-you-act gate is a reasonable instinct but
costs an extra tap on every decision, most of which (a routine one-day
sick leave) don't need it — worth revisiting as a *conditional* gate
(only on the low-balance case) if reflexive over-approving turns out to
be a real problem post-launch, not as v1's default. Split, Focused Queue
solves a real problem — clearing many requests back to back without
losing place — but a Philippine SME manager is realistically approving
one or two requests a week, not running a triage desk, so the
permanent-width rail was set aside as paying rent most visits won't use.

HTML mockup: [[../ux-pages/team-approvals.html]]
