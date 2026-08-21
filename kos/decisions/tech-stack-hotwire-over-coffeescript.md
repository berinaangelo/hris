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

Final stack: Rails, Hotwire (Turbo + Stimulus), SCSS, Bulma, MySQL.
