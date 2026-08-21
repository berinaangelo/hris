---
title: spacing-bulma-default
tags: [hris, design, spacing]
date: 2026-08-21
---

Spacing/layout scale for the HRIS reuses Bulma's built-in spacing
helpers as-is, rather than defining a custom base-unit scale.

Bulma's default `$spacing-values` Sass map: `0` (0), `1` (0.25rem),
`2` (0.5rem), `3` (0.75rem), `4` (1rem), `5` (1.5rem), `6` (3rem) —
exposed as margin/padding helper classes (`m-0`…`m-6`, `p-0`…`p-6`,
plus directional variants `mt-`/`mr-`/`mb-`/`ml-`/`mx-`/`my-` and the
same for `p-`). Every card, form, table, and section in the app should
reach for these helper classes rather than one-off pixel/rem values.

Why: no reason to invent a parallel scale when the framework already
ships one — same reasoning as reusing Bulma's `$primary`/`$link`/
`$success`/`$warning`/`$danger` variables for
[[color-palette-ink-and-amber|the color palette]] instead of a separate
token system. One less thing to design, document, or drift from.
