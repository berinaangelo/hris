---
title: login-page-split-panel
tags: [hris, design, ux, login]
date: 2026-08-21
---

Chose "Split Panel" for the HRIS login page — a two-column layout (brand
panel + form) — over "Centered Card" (single card on the surface color,
the minimal/cheapest default) and "Bare Minimum" (slim top bar, no
card, least visual weight). Full comparison, all three built on the
same tokens:
https://claude.ai/code/artifact/544e64e1-91cd-4bf4-8cc3-be895c9f56ad

**Layout:**
- Left panel (~44% width, collapses to full-width above the form on
  narrow viewports): ink-navy background, wordmark top-left, a headline
  pulled directly from the v1 [[../projects/hris/PLAN.md|PLAN]]'s god
  moments ("Log in and your profile, manager, and team are already
  right."), then three short bullet lines restating the other god
  moments (real balance before requesting, same-day decision
  notification, one record never updated twice), each with a
  check-circle icon.
- Right panel (~56%): white background, the form — work email, password
  (with show/hide toggle), Remember me + Forgot password inline, one
  amber "Sign in" CTA, footer text pointing to HR instead of a sign-up
  link.

Built on tokens already decided elsewhere, nothing new introduced here:
[[../ui/color-palette-ink-and-amber|Ink & Amber]] palette,
[[../ui/type-system-neutral-and-efficient|Archivo/Work Sans]] type,
[[../ui/iconography-lucide|Lucide-style]] icons,
[[../ui/motion-functional-microMotion|functional micro-motion]] for the
submit button's pending state, and
[[../ui/form-validation-inline-only|inline-only]] validation on the
form fields.

**Not yet a decision, carried over as an open assumption:** no
self-registration link — the v1 plan has HR add the employee, so the
footer says "ask your HR administrator" instead of "Sign up". Remember
me and Forgot password are conventional additions, not decided
anywhere else; cheap to cut if they turn out unwanted.

Why this one: the login screen is also the first thing a prospect sees
during a sales demo or trial, and the left panel spends that space on
the product's own god moments instead of stock marketing copy — the
value prop is visible before anyone signs in. Costs more than the
Centered Card default: a real two-column responsive layout, and bullet
copy on the left panel that has to stay in sync with the roadmap as god
moments change. Bare Minimum was set aside for the opposite reason —
it's the cheapest of the three, but gives up the demo-moment payoff
entirely, and this system's signature moments are worth showing
somewhere.

HTML mockup: [[../ux-pages/login-page.html]]
