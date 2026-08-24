---
title: bulma-vendored-prefixed
tags: [hris, tech-stack, design]
date: 2026-08-24
---

Bulma is actually pulled into the Rails app now (see
[[../tech-stack-hotwire-over-coffeescript|the original tech-stack
decision]], which named Bulma as part of the final stack but never got
executed — `application.scss` stayed plain hand-written CSS through
all four real-UX-pass batches). Between that decision and today, four
batches of hand-rolled components landed with their own `.card`,
`.field`, and `.hero` classes (among others) — completely different
shapes than Bulma's own. Loading Bulma unscoped now would silently
override all of them.

**How it's wired in:**
- Vendored at `app/assets/stylesheets/bulma/` — `npm bulma@1.0.4`'s own
  `sass/` directory, copied in directly (no gem, no Node build step;
  `dartsass-rails` already resolves `app/assets/stylesheets` as a Sass
  load path, so `@use "bulma"` in `application.scss` just works).
- `$class-prefix: "bulma-"` namespaces every class Bulma generates
  (`.bulma-card`, `.bulma-field`, `.bulma-hero`, `.bulma-button`, ...)
  so nothing it outputs can collide with the app's own classes of the
  same name. `$cssvars-prefix` was already `"bulma-"` by Bulma's own
  default, so its CSS custom properties (`--bulma-primary` etc.) were
  never a collision risk either.
- The vendored copy's `_index.scss` no longer forwards `base` (Bulma's
  reset layer touches bare elements — `body`, `table`, `h1`-`h6`,
  `ul`, `hr`, ... — directly, with no class for `$class-prefix` to
  namespace; nothing else in Bulma depends on it, so dropping it was
  safe and removes the last real collision surface).
- **One deliberate exception:** the `m-`/`p-`/`mt-`/`my-`/etc. spacing
  helpers stay **unprefixed**, matching the standing
  [[spacing-bulma-default]] decision — nothing else in the app uses
  those class names, so there was nothing for them to collide with,
  and prefixing them would have broken that decision's own "use them
  as-is" premise. Sass can't configure `$class-prefix` two different
  ways for one loaded module in the same compilation, so this couldn't
  be done by reusing Bulma's own `helpers/spacing.scss` with a second
  config — `helpers/_index.scss` no longer forwards `spacing`, and
  `application.scss` generates the same scale unprefixed as a small
  standalone block instead.
- Color mapping uses the one already decided in
  [[color-palette-ink-and-amber]]'s own "Bulma mapping" line
  (`$primary`/`$link`/`$info`) plus the fixed status colors
  (`$success`/`$warning`/`$danger`) from the same doc. Font-family and
  base radius aren't decided anywhere else — set here to keep
  `.bulma-*` classes visually consistent with the rest of the app for
  whenever a page actually reaches for them, not from an existing
  decision.

**Not done:** no page actually uses any `.bulma-*` class yet (or
unprefixed spacing helper, until the one currently mid-edit on
`sessions/new.html.erb`) — this batch only makes Bulma available,
scoped so it's risk-free to reach for on a future page/feature.

Why prefixed-and-vendored over the alternatives: renaming the app's
own `.card`/`.field`/`.hero` (and every template using them, across
four already-shipped batches) to free those names for Bulma was the
more invasive option for the same end state. Loading it unscoped was
rejected outright — it would have visibly broken every already-built
page. `$class-prefix` is a first-class, documented Bulma 1.x feature
built for exactly this situation, so reaching for it over a CSS
`@scope`-based wrapper (browser-support risk, and doesn't stop
Bulma's own bare-element reset from leaking out the way dropping
`base` does) was the straightforward choice.
