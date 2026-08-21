---
title: notifications-nav-badge-counts
tags: [hris, design, notifications]
date: 2026-08-21
---

Chose "Nav Badge Counts" for MVP in-app notification treatment — a live
count badge on the Team/Company tabs showing how many things currently
need action — over "Toast Only" (ephemeral pop-up, nothing persists)
and "Notification Center" (a persistent bell + dropdown with a full
notification log). Full comparison:
https://claude.ai/code/artifact/99249d42-b2f6-4353-b709-9d0fec8dc9b9

**What it is:** the count is a live query against data that already
exists (`pending leave requests`, `pending PIP reviews`, etc.) — not a
stored notification log. It renders as a caution-colored count pill on
the relevant tab in
[[navigation-me-team-company|Me / Team / Company]], reusing
[[badge-system-four-categories|the badge system]] directly. No new
table.

Email stays the actual "you were told to act" channel — this was
already the v1 notification mechanism (see
[[../projects/hris/PLAN.md]]); the nav badge only answers "how many,
right now" the instant you glance at the nav. Email stays plain text
for v1 — a branded HTML template is a cheap upgrade later, not a v1
decision.

Why not the alternatives: "Toast Only" and "Notification Center" were
both set aside for MVP specifically — Toast Only has no in-app recall
if you miss it live; Notification Center is the most capable of the
three but needs a full `notifications` table, read/unread state, and a
dedicated UI, none of which the v1 god-moments actually require. Worth
revisiting Notification Center post-MVP if usage shows people need to
review notification history, not just current counts.
