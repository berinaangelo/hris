---
title: thirteenth-month-toggle-inline-payout-preview
tags: [hris, design, ux, company, admin, payroll]
date: 2026-08-22
---

Chose "Toggle + inline payout preview" for the 13th Month Pay control — not
a standalone page, a company-level toggle
(`thirteenth_month_pay_enabled`, default true) on the new HR-Admin **Payroll
Settings** screen (Company → Payroll → Settings), per
[[../thirteenth-month-pay-mandatory-in-ph.md]] — over "Plain toggle row" (a
bare switch, no extra detail) and "Compliance-guarded toggle" (clicking the
switch opens a confirmation requiring an exemption reason before it takes
effect). Full comparison, same Payroll Settings shell and figures on
identical tokens: https://claude.ai/code/artifact/5125bc52-7899-4aed-9c6e-4cabc590a705

**Layout — the chosen option:**
- A dedicated settings card, same visual weight as the Pay Schedule and
  Statutory Rate Tables cards above it on the same screen: a switch on the
  right, a one-line explainer on the left ("Mandated for rank-and-file
  employees under PD 851, with narrow exemptions only").
- Switching it ON reveals an inline preview panel directly under the
  toggle: a formula reminder ("total basic salary earned in 2026 ÷ 12,
  prorated by months worked"), then three stat tiles — employees covered,
  this year's projected payout at current run-rate, and the Dec 24 legal
  deadline. Switching it OFF collapses the panel to a single muted caption
  ("13th month pay is currently disabled for this company — no payout will
  be computed at year-end").
- No confirmation step and no recorded exemption reason on disable — the
  toggle itself stays a plain, instant switch; only what's shown beneath it
  changes.

Built on tokens already decided elsewhere:
[[color-palette-ink-and-amber|Ink & Amber]] palette,
[[type-system-neutral-and-efficient|Archivo/Work Sans/IBM Plex Mono]] type,
[[badge-system-four-categories|four-category badges]] (used sparingly here —
just a neutral "Fixed for v2" badge on the untouched Pay Schedule card
shown for page context).

**Carried over, not re-decided here:** Pay Schedule (semi-monthly, fixed for
v2) and the Statutory Rate Tables link card are shown identically across
all three options in the comparison — they aren't part of what this
decision is about, just the page context the toggle now lives inside of.
Projected payout figures are illustrative mock data; no live computation is
wired. This is also the first mockup of the Payroll Settings screen itself
— it didn't exist as a page before this toggle needed a home.

Why this one: the recommendation going in was the compliance-guarded
option — clicking the switch off would require picking a recorded
exemption reason, matching the weight
[[payroll-run-detail-master-table-edit-drawer|Payroll Run Detail]]'s own
finalize step gives to other consequential, hard-to-reverse payroll
actions. The user chose the lighter option instead: useful information
(who this touches, roughly what it costs, when it's due) without adding a
confirmation gate to a switch that's expected to stay on. Recorded here as
the deliberate choice — not re-litigated — should someone later want the
disable path to require a reason on file.

HTML mockup: [[../ux-pages/payroll-settings.html]]
