---
title: org-chart-classic-top-down-tree
tags: [hris, design, ux, company, people]
date: 2026-08-23
---

Chose "Classic top-down tree" for the Org Chart / Hierarchy Visualization
page — surfacing the v1 org-structure field (`manager_id`) as its own
view, per [[../projects/hris/PLAN.md|the plan's]] "org structure drives
directory/org-chart view" line — over "Indented nested list" (the same
accordion mechanic as
[[people-directory-card-grid-with-list-toggle|People Directory]]'s
department groups, scaled to any headcount in one column) and
"Person-centered chain view" (pick anyone, see only their chain up and
reports down). Full comparison, all three built on the same tokens:
https://claude.ai/code/artifact/314c79fe-8e51-478e-9840-2472cf61ee1a

**Layout — the chosen tree:**
- Root node is the company itself ("Alon Pay") rather than an invented
  CEO/Owner — the directory data shows all four department heads
  (Ramon Dela Cruz, Ferdinand Ocampo, Miguel Santos, Andrea Cruz) with no
  manager, so the tree fans them straight from a company-level root
  instead of assuming a person that isn't in the data. The root uses a
  square avatar (not circular) to read as "not a person" at a glance.
- Each manager card is itself the collapse/expand control — clicking it
  toggles a dashed-border "children" cluster below, no separate chevron
  button to learn. All branches open by default since the whole roster
  (12 people) fits on screen without it.
- Individual contributors with no reports (Andrea Cruz) sit as a plain
  leaf card at the same row as the managers, no empty collapse control
  rendered for them.
- Same roster as People Directory throughout: Ramon Dela Cruz's 5
  Engineering/Design reports, Ferdinand Ocampo's 1 (Finance), Miguel
  Santos's 1 (Sales), Andrea Cruz with 0 (People). Offboarded employees
  (Jonas Rivera) excluded — an org chart answers who reports to whom
  right now, not headcount history.

Built on tokens already decided elsewhere:
[[color-palette-ink-and-amber|Ink & Amber]] palette,
[[type-system-neutral-and-efficient|Archivo/Work Sans/IBM Plex Mono]]
type, and the same avatar/dept-tag components already built for
[[people-directory-card-grid-with-list-toggle|People Directory]].

**Carried over, not re-decided here:** single-manager reporting only, no
dotted-line/matrix relationships, matching the plan's scope. Search is
illustrative, not wired — a real build follows the sanitized-params
pattern in `decisions/rails-pagination-and-batch-export-processing.md`
if/when this needs filtering at scale. Clicking a node doesn't yet route
anywhere (no link to Employee Detail) — shown as a hover affordance only,
same as People Directory's own unbuilt row-click.

Why this one: "org chart" already carries a fixed mental model — boxes
and lines, shape of the company visible in one glance (Jakob's Law) —
and the god-moments framing used throughout this project favors seeing
the whole structure at once over picking a person first. The company is
small enough today that the full tree fits in one horizontal scroll, so
the option's own scale risk (a department with 30+ reports needing its
branch collapsed by default) isn't a real cost yet. Indented Nested List
is the better fallback once headcount grows past what a fanned-out tree
can hold on screen — noted for later, not built now. Person-Centered
Chain View is a better fit as a component embedded elsewhere (e.g.
Employee Detail's Org Position section, to answer "who's above/below
this one person") than as this page's primary landing view.

HTML mockup: [[../ux-pages/org-chart.html]]
