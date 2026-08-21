---
title: empty-states-guided
tags: [hris, design, empty-states]
date: 2026-08-21
---

Chose "Guided" for the HRIS empty-state system — icon, headline, one
line of context, and a CTA button shown only when there's an actual
next action — over "Minimal" (icon + one line, nothing else) and
"Contextual" (Guided plus a permanent "learn more" link on every
state). Full comparison across three real v1 scenarios:
https://claude.ai/code/artifact/0b440eef-32fd-4306-8980-bddfead94ce8

**Structure:** gray icon above the text (inside the box, at the top) →
bold headline → one-line muted subtext → CTA button, conditional on
whether there's something to do. E.g. "No employees yet" gets
"+ Add Employee"; "You're all caught up" (no pending approvals) gets no
button, since there's nothing to push.

Why this one: it's the version that does something for a brand-new
customer on day one — the hardest empty state in the system, since a
company with zero employees has no other way to learn what to do
first. Directly serves the grandma test (see
[[../projects/hris/PLAN.md]]) — no manual needed, the next step is
just there. The conditional CTA mirrors the badge system's
"omit when not needed" rule (see
[[badge-system-four-categories]]).

**"Contextual" explicitly deferred, not cut** — set aside specifically
for its ongoing cost, not its UI: every "learn more" link needs a help
page or explainer written and kept in sync as the feature it describes
changes. That's a content-maintenance commitment, not a design cost.
Worth revisiting post-v2 for one specific case (a first-time PIP cycle,
an unfamiliar compliance feature) rather than applying it everywhere by
default now.
