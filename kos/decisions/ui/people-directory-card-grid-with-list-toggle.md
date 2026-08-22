---
title: people-directory-card-grid-with-list-toggle
tags: [hris, design, ux, company, admin]
date: 2026-08-22
---

Chose "Photo-Forward Card Grid" for the v1 People Directory — the
HR-Admin-only company roster under Company → People Directory (see
[[navigation-me-team-company]]) — over "Data Table, Comprehensive
Columns" (a dense searchable table) and "Grouped by Department,
Collapsible Sections" (accordion sections per team). Card grid ships
as the default view, with a card/list toggle added in the toolbar so
the table option isn't lost — switching to list reuses the data-table
option's exact markup, one click, no separate page. Full comparison,
all three built on the same tokens:
https://claude.ai/code/artifact/2f32efcf-9d98-4c42-b895-f69ebc8ee912

**Layout:**
- Toolbar: search input, department filter chips, a card/list view
  toggle (two icon buttons, card highlighted by default), and the
  primary "Add Employee" action.
- Card view (default): a responsive grid of photo-forward cards —
  avatar, name, role, department tag, start year. Clicking a card goes
  to Employee Detail (not built yet — shown as a hover affordance).
- List view (toggle): the exact table from the Data Table option —
  Employee / Role / Department / Manager / Start Date / Status columns,
  comfortable density per
  [[data-tables-comfortable-density]], with pagination controls below.
- Active employees show no status badge (default/steady state);
  "Offboarded" is the one status that gets a badge (Neutral), per
  [[badge-system-four-categories]]'s "badges are for deviation, not
  every state" rule — hidden by default, previewable via a demo toggle
  in this mockup.

Built on tokens already decided elsewhere:
[[color-palette-ink-and-amber|Ink & Amber]] palette,
[[type-system-neutral-and-efficient|Archivo/Work Sans/IBM Plex Mono]]
type, [[badge-system-four-categories|four-category badges]], and
[[data-tables-comfortable-density|comfortable table density]] for the
list view.

**Carried over, not re-decided here:** Company tab is HR-Admin-only,
absent (not filtered) for anyone else, per
[[navigation-me-team-company]]. Same 5-person Engineering team as
[[team-approvals-inbox-inline-actions]], with Finance/Sales/Design/
People departments added so the mockup reads as a real company-wide
roster rather than one team repeated. Search/filter controls are
illustrative; a real build follows the sanitized-params pagination
guard in
[[../rails-pagination-and-batch-export-processing]].

Why this one: card grid is the friendliest way to browse a company —
good for a new HR admin putting faces to names, which matters more for
this screen than for an internal work-queue like Team Approvals. The
toggle is what makes card the safe v1 default rather than a tradeoff:
the moment someone needs to search/sort/cross-reference at scale (the
Data Table option's actual strength), it's one click away, not a
different page or a lost view. Grouped by Department was the closest
runner-up — mirrors how HR actually thinks about the org — but was set
aside since the toggle already gets most of its "org structure at a
glance" value through the department filter chips, without needing a
third view to build and maintain.

HTML mockup: [[../ux-pages/people-directory.html]]
