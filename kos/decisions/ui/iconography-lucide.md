---
title: iconography-lucide
tags: [hris, design, iconography]
date: 2026-08-21
---

Chose Lucide for the HRIS icon set — thin single-weight stroke, detail
reduced to the minimum that still reads — over Heroicons (clean 1.5px
outline, the most common SaaS default) and Phosphor (broadest set,
7,000+ icons, with thin/regular/bold/fill weight variants). Full
comparison across six core concepts plus each applied to the
Me/Team/Company nav:
https://claude.ai/code/artifact/62eb312d-761a-4232-973a-7dd20317a7af

All three are free, open-source, and self-hostable as inline SVG — no
CDN dependency, consistent with keeping the app self-contained.

Why this one: same reasoning already on file for
[[type-system-neutral-and-efficient|choosing Work Sans/Archivo]] over
the humanist and slab-serif directions — a style with no opinion of its
own lets dense screens of names and currency stay what people actually
read. One weight only, so there's nothing to standardize or enforce
later.

Why not Phosphor: its five-weight range (thin/light/regular/bold/fill)
is real capability this app doesn't need — active-tab state in
[[navigation-me-team-company|Me/Team/Company]] is already solved by
background color, not icon weight, so the flexibility would just be an
unused axis someone could accidentally drift across screens.

Smaller total library than Phosphor (~1,400 icons) — an occasional very
specific HR concept may need a hand-drawn addition rather than an
off-the-shelf glyph. Heroicons stays the documented fallback if that
turns out to be a real gap.
