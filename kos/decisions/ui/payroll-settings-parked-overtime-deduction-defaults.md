---
title: payroll-settings-parked-overtime-deduction-defaults
tags: [hris, design, ux, company, admin, payroll]
date: 2026-08-23
---

Added two new sections to the [[thirteenth-month-toggle-inline-payout-preview|Payroll
Settings]] screen — **Overtime Rules** and **Deduction Defaults** — shown as
locked/disabled placeholders, not live settings. Requested directly by the
user, no three-option comparison (standing pattern as of 2026-08-23, see
[[../../hris-ux-pages-workflow|workflow memory]]). Parked here in case
payroll scope expands to cover them later; nothing here is wired to any
state or persisted.

**What's disabled and why:** per
[[../../projects/hris/features/payroll-v2/PLAN.md|the payroll-v2 plan]], OT
and deductions are both entered as manual line items per payroll run for
v2 — no automatic multiplier or default-deduction engine is in scope. The
fields shown are illustrative of what a future configurable version might
look like, not a commitment to build them:

- **Overtime Rules** — regular OT multiplier (1.25×), rest day/holiday
  multiplier (1.30×), night differential (10%). Standard PH labor-code
  reference figures, shown as disabled `<input>` fields.
- **Deduction Defaults** — cash advance repayment cap ("No cap set"),
  default deduction categories ("Bonus, Deduction, Cash advance, OT" — the
  plan's own manual line-item types). Same disabled-field treatment.

Both cards reuse the existing `.settings-card` / `.settings-row` /
`.settings-fields` structure from the Pay Schedule card, get a small lock
icon (Lucide, per [[../iconography-lucide]]) next to the heading, and a
neutral "Parked for later" badge — same visual family as the existing Pay
Schedule card's "Fixed for v2" badge, which also picked up the lock icon
for consistency (its own fields and badge text left untouched, already
decided).

**Disabled-field styling:** plain `<input disabled>` with muted text
(`--neutral` on `--surface`) and `cursor: not-allowed` — no fake toggle
switches or interactive-looking controls, since nothing here responds to
input. Shown identically across all three tabs of the 13th Month Pay
comparison mockup (page context, not part of that comparison, same
treatment the Pay Schedule/Rate Tables cards already got).

HTML mockup: [[../ux-pages/payroll-settings.html]]
