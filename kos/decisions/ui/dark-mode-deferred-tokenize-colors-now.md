---
title: dark-mode-deferred-tokenize-colors-now
tags: [hris, design, color, scope]
date: 2026-08-21
---

Dark mode is deferred out of v1 — it doesn't touch any of the v1 god
moments (see [[../projects/hris/PLAN.md]]), it's purely aesthetic, and
this system is mostly used in an office/HR context during business
hours, not a context where dark mode earns its keep the way it does in,
say, a code editor. Revisit post-MVP if users actually ask for it.

**What to do now anyway, because it's nearly free today and expensive
later:** implement the color system — [[color-palette-ink-and-amber]]
and the four badge categories — as named Sass/CSS variables in the
Bulma build (`$color-bg`, `$color-surface`, `$color-ink`,
`$color-badge-caution-bg`, etc.), never as hardcoded hex values
scattered through views/partials.

Why: if colors are hardcoded now, adding dark mode later means hunting
every view for every literal hex — a real regression risk once payroll,
statutory tables, and badges are all shipped. If they're tokenized from
the start, dark mode later is "define a second set of token values," a
Sass/CSS-only change with zero view changes. Same abstraction-once
principle as the badge system's four fixed categories.
