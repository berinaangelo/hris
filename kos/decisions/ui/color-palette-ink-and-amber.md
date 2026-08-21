---
title: color-palette-ink-and-amber
tags: [hris, design, color]
date: 2026-08-21
---

Chose "Ink & Amber" for the HRIS visual design — a complementary color
scheme (navy and burnt orange sit opposite each other on the wheel) —
over two other proposed options (Steady Blue: analogous blue/teal; Sage
& Clay: split-complementary green/clay/plum). Full comparison with
swatches and a mockup of each applied to the leave-approval card:
https://claude.ai/code/artifact/6011d462-8293-4977-9613-ba27fca001b9

**Palette:**
- Primary / ink: `#1B2A4A` (deep navy — chrome, headers, nav)
- Accent / CTA: `#E8630A` (burnt orange — spent almost nowhere except
  the primary action per screen: Approve, Submit, Save)
- Primary, light: `#3E5378`
- Neutral: `#697488`
- Surface: `#F6F7F9`

**Bulma mapping:** `$primary: #1B2A4A`, `$link: #E8630A`,
`$info: #3E5378`.

Semantic status colors stay the fixed set used across every palette
option — `$success: #16A34A`, `$warning: #D97706`, `$danger: #DC2626` —
see [[../projects/hris/PLAN.md|v1 PLAN]]'s "god moments" principle:
status color is convention, not brand expression.

Why this one: true complementary contrast, spent on exactly one element
per screen, makes the primary action unmissable — a good fit for a
system whose signature moment is "approve in one click." The accent was
deliberately shifted to burnt orange rather than gold specifically so
it never sits close enough to the warning/pending semantic (`#D97706`)
to be misread as a caution instead of an action.
