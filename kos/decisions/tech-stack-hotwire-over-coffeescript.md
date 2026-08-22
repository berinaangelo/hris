---
title: tech-stack-hotwire-over-coffeescript
tags: [hris, tech-stack, rails]
date: 2026-08-21
---

Chose Hotwire (Turbo + Stimulus) with Rails import maps over the
originally-planned CoffeeScript for the HRIS project (see
[[../projects/hris/PLAN.md]]).

Why: CoffeeScript + Sprockets was the Rails default years ago and is
effectively dead upstream — Rails itself moved off it. Hotwire is Rails'
own default since Rails 7, is a direct spiritual successor to
jQuery/CoffeeScript "sprinkles" (Stimulus controllers attach small JS
behaviors via `data-controller` attributes), and needs no Node/webpack/
esbuild build pipeline at all (import maps).

It also matches the ruthless-simplicity approach this project is being
scoped with: the HRIS's signature moments (approve a leave request and
the list updates instantly, balance updates live after a request) are
exactly what Turbo Streams/Frames do server-rendered, with no separate
JSON API to build and maintain.

SCSS and Bulma stay unchanged — both are still current, no reason to
swap. Only reach for a heavier JS framework (React/Vue + esbuild) later,
for one specific screen, if it turns out to genuinely need client-side
state beyond what Stimulus covers — not upfront.

**Addendum (2026-08-22): no Alpine.js, no jQuery.** Explicitly
considered and rejected Alpine.js as a state-management layer — it
overlaps Stimulus almost entirely (both are "sprinkle interactivity on
server-rendered HTML" tools) and running both would fragment where UI
state lives with no capability gain. jQuery is out for the same
reason and because it'd pull in a dependency the importmap-based setup
doesn't need. Note the distinction this project runs on: Hotwire gives
*DOM* reactivity (an event — user action via Stimulus, or a server
push via Turbo Streams — triggers an explicit DOM patch), not *data*
reactivity (no `x-data`-style dependency graph that auto-rerenders on
variable change). That gap only matters for fine-grained client-only
computed values, which this app's screens don't need. Server cost of
Turbo Streams (Action Cable connections) is a non-issue at HRIS
traffic scale (bounded by headcount); reserve Streams for genuinely
live server-push updates and use Turbo Frames for everything else, to
keep connection count down.

Final stack: Rails, Hotwire (Turbo + Stimulus), SCSS, Bulma, MySQL.
