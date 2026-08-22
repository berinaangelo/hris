---
title: rails-datatable-pagy-turbo-frame-pattern
tags: [hris, rails, frontend, ui]
date: 2026-08-22
---

No client-side datatable library (DataTables.js, Tabulator, Grid.js,
AG Grid) for HRIS list screens — People Directory, Payroll Runs,
Company tab, Reports. Default pattern instead: a server-rendered
`<table>` + Pagy for pagination (see
[[rails-pagination-and-batch-export-processing]]) + a Query Object
for sort/filter (see [[rails-query-objects-for-reused-queries]]),
wrapped in a `turbo_frame_tag` so column-header clicks and pagination
links swap just the frame, no full page reload. The sort-direction
arrow indicator is a small Stimulus controller, not a JS library (see
[[tech-stack-hotwire-over-coffeescript]]).

Why: DataTables.js requires jQuery, already ruled out. The DB/server
already does sort+filter+paginate correctly and scales to large
tables, unlike a client-side library re-sorting a full in-memory
dataset; Turbo Frames give the "no full reload" UX without a
client-side table engine.

Fallback, not adopted — only if a specific screen needs it later:
Tabulator.js. No jQuery dependency, ships an ESM build that pins
cleanly via import maps, wraps in one Stimulus controller. Reserved
for a screen that needs genuine client-side inline editing across
many rows (e.g. a payroll bulk-adjustment grid), not for standard
list screens. Grid.js and AG Grid were considered and rejected —
Grid.js is redundant with Tabulator's superset of features, AG Grid
is built for spreadsheet-grade grids and heavier than this app needs
anywhere on its current page list.

**How to apply:** any new list/table screen starts with the Pagy +
Turbo Frame + Query Object pattern by default. Only escalate to
Tabulator if the screen requires real-time client-side editing across
many rows without a per-cell round trip — flag that need explicitly
rather than defaulting to it.
