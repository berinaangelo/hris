---
title: form-validation-inline-only
tags: [hris, design, forms]
date: 2026-08-21
---

Chose "Inline Only" for HRIS form validation feedback — each invalid
field shows its own error message in place, no top-of-form summary by
default — over "Summary + Inline" (a red error-summary box plus inline
messages, always) and "Inline + Live" (adds Stimulus-driven validation
on blur, before submit). Full comparison, tested on both the shortest
form (leave request) and longest (add employee):
https://claude.ai/code/artifact/4051f6bf-cf7e-4ae0-9c1b-9a7f99d8c208

**Flex rule, not a second system:** if a submit ever comes back with 3
or more errors at once, the Summary option's error-list box appears
automatically above the same inline messages. A simple count
threshold, not two parallel validation designs to maintain — the one
long form in the system (Add Employee) gets a scannable list when it
actually has several errors, while every short form (leave request, KPI
entry, loan entry) stays as light as it should be.

Timing, for all cases: server-side validation on submit via the normal
Rails/Hotwire round-trip — no client-side validation layer.

Why "Inline + Live" (blur-triggered client validation) was set aside:
consistent with [[tech-stack-hotwire-over-coffeescript]] — it needs a
Stimulus controller per validated field/rule, and those rules would
have to approximately mirror the server's real validation logic, a
second copy that can quietly drift out of sync over time. Worth
reconsidering only if a specific form's server round-trip is proven too
slow to feel good, not by default.
