---
title: data-tables-comfortable-density
tags: [hris, design, tables]
date: 2026-08-21
---

Chose "Comfortable" row density for HRIS data tables — ~46px rows,
subtle zebra striping on wide tables — over "Compact" (~34px, no
zebra, maximum rows per screen) and "Spacious" (~60px, card-like, most
touch-friendly). Tested on the payroll register and people directory:
https://claude.ai/code/artifact/af9ce6dc-65b1-4c77-a4c8-00a3ff728504

One density for every table in the app — no per-screen toggle.

Why this one: the system's heaviest, most frequent screens — payroll
registers, employee directories, reports — are exactly what a density
decision should optimize for. Compact's tighter rows start crowding
the [[badge-system-four-categories|badge pills]] and IBM Plex Mono
tabular figures that are already load-bearing parts of this design;
Spacious is the friendlier fit for a short mobile list (My Payslips)
but the wrong default for the admin screens this app actually lives in
most. The zebra striping (reusing existing surface tokens, no new
color) earns its place specifically on the payroll register, where
several currency columns sit side by side and a reader's eye is most
likely to slip between rows.

If a specific screen later genuinely needs a friendlier touch target
(e.g. a mobile self-service list), that's solved by that screen's own
layout, not by making table density itself configurable.
