---
title: rails-viewcomponent-for-reusable-ui
tags: [hris, rails, frontend, ui]
date: 2026-08-22
---

Pages get built component-based for reusability, using the
**ViewComponent** gem (`gem "view_component"`), and admin-facing
pages render through an enforced layout shell rather than ad-hoc
`content_for` regions.

**Component-based views (ViewComponent).** Structure:
`app/components/*_component.rb` with a co-located sidecar template
(`*_component.html.erb`) — the closest Rails equivalent to a Vue SFC.
Use `renders_one` / `renders_many` slots for composition (the Vue-slot
equivalent), e.g. a card component exposing a `renders_one :actions`
slot. Test in isolation via `ViewComponent::TestCase`, as its own test
category alongside the existing model/controller/interactor split in
[[rails-testing-minitest-factorybot-faker]].

Priority extraction candidates: `BadgeComponent` (status→color
mapping, replaces per-view duplication per
[[rails-presenters-decorators-for-view-formatting]] and
[[badge-system-four-categories]]), `DataTableComponent` (wraps the
Pagy + Turbo Frame + sortable-header pattern from
[[rails-datatable-pagy-turbo-frame-pattern]] so every list screen
reuses one component instead of copy-pasted markup), `StatTileComponent`,
`NavItemComponent`.

**Layout enforcement — `Layouts::AdminComponent`.** Considered vs
plain Rails `content_for` regions on
`app/views/layouts/application.html.erb`; picked a dedicated layout
component instead because it's an enforced contract (a missing
required slot fails loudly) vs `content_for` silently no-op-ing if a
view forgets to fill a region. All admin-facing pages — the mockups
under `decisions/ux-pages/` (People Directory, Payroll Runs, Company
tab, etc., see [[../projects/hris/PLAN.md]]) — render through
`Layouts::AdminComponent`, which owns the sidebar nav + topbar chrome
and exposes slots (e.g. `renders_one :page_header`) for page-specific
content — analogous to a Vue `App.vue` wrapping `<router-view>`.
Non-admin pages (login) keep the existing plain
`application.html.erb` layout as-is.

Alternatives considered for the component layer: Phlex (pure-Ruby, no
ERB — bigger shift from the existing ERB-based views, smaller
ecosystem) and disciplined partials (zero new dependency, but no real
encapsulation or enforced contract). ViewComponent chosen as the
de-facto Rails standard, zero npm/build-step impact, works fine with
the importmap-based [[tech-stack-hotwire-over-coffeescript]] setup.

**How to apply:** any new page/screen is built as `Layouts::AdminComponent`
(or the plain layout, if non-admin) wrapping page-specific
ViewComponents, pulling shared UI (badges, tables, stat tiles, nav
items) from `app/components/` rather than writing one-off ERB per page.
