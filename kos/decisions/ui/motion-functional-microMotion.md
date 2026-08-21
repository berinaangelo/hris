---
title: motion-functional-microMotion
tags: [hris, design, motion]
date: 2026-08-21
---

Chose "Functional Micro-motion" for HRIS interaction motion — small,
purposeful transitions (~180ms) that exist only to confirm an action
worked, nothing decorative — over "None" (pure Turbo default, instant
DOM swaps) and "Full Interaction Layer" (spring-eased list motion,
Turbo Drive page-morph transitions, badge "pop" animations). Live,
clickable comparison: https://claude.ai/code/artifact/868a3a15-0fb6-4e84-ad8d-d25defb73c50

**What it covers:** a ~180ms fade + height-collapse when a row leaves a
list after an action (e.g. an approved request leaving the Team
Approvals inbox), a brief pending/disabled state on submit buttons
during the server round-trip, and the same treatment for
[[notifications-nav-badge-counts|nav badge count]] changes. All
transitions respect `prefers-reduced-motion`.

Why this one: closes the one real gap "None" has — confirming a click
actually registered before the UI changes — without paying "Full
Interaction Layer"'s cost (spring easing tuning, page-morph edge cases
across every screen) for something explicitly non-load-bearing. Matches
the identity already set by [[iconography-lucide|Lucide]] and
[[type-system-neutral-and-efficient|Work Sans/Archivo]]: quiet, no
stylistic opinion, present exactly long enough to do its one job.

"Full Interaction Layer" stays documented as a later finishing pass,
worth revisiting once the core product is built and stable — not a
decision that changes what gets built now.
