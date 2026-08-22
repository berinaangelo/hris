---
title: employee-benefits-repeatable-plan-cards
tags: [hris, design, ux, company, admin, benefits]
date: 2026-08-22
---

Chose "Repeatable Plan Cards" for the Benefits tab content on
[[employee-detail-inline-edit-with-reserved-tabs|Employee Detail]] —
one card per benefit enrollment, each independently pencil-editable —
over a "Single Flat Section" (one record, mirroring Personal & Contact
exactly) and a "Compact Expandable List" (row per plan, click to
expand into edit). Full comparison, all three built on the same
tokens: https://claude.ai/code/artifact/8afeab16-c72f-4809-9663-befcbf905bbe

**Layout — the chosen option:**
- "Benefits" section holds zero-to-many cards, one per enrollment
  (e.g. HMO from one provider, a separate group life or accident
  policy from another), each with its own Plan name / Provider /
  Effectivity date fields and its own dependents list (name +
  relationship).
- Each card edits independently in place via its own pencil icon — no
  modal, same inline-edit pattern as every other Employee Detail
  section. A "+ Add plan" button on the section header appends a new
  card; each card also gets its own remove action.
- Dependents are a simple editable list per card (text name + a
  relationship select: Spouse/Child/Mother/Father), matching the
  record-keeping-only scope — no eligibility rules or cost-sharing.
- No status badge — there's no deviation state to flag for a benefit
  record, unlike Loan Ledger's Active/Paid-off, per
  [[badge-system-four-categories]]'s "badges are for deviation" rule.
- Zero-state uses the [[empty-states-guided]] shape (icon + headline +
  subtext + "+ Add benefit plan" CTA) for a brand-new hire with
  nothing on record yet.

Built on tokens already decided elsewhere:
[[color-palette-ink-and-amber|Ink & Amber]] palette,
[[type-system-neutral-and-efficient|Archivo/Work Sans/IBM Plex Mono]]
type, and the same identity-strip/field-grid/section components
already built for
[[employee-detail-inline-edit-with-reserved-tabs|Employee Detail]].

**Carried over, not re-decided here:** record-keeping only — no
enrollment workflow, eligibility rules, cost-sharing computation, open
enrollment periods, claims/reimbursement tracking, or carrier API
integrations, per
[[../projects/hris/features/benefits/PLAN.md|the Benefits plan]] and
[[vendor-fragmented-features-record-keeping-only]]. HR types the plan
in after enrolling the employee directly with the carrier.

Why this one: it's the only option that doesn't quietly assume exactly
one benefit plan per employee. A Single Flat Section reads cleanly for
that one-plan case but has no answer once a second, unrelated
enrollment needs recording (HMO plus a separately-provisioned life or
accident policy is a common PH SME pattern) short of cramming two
plans' fields into one section. A Compact Expandable List solves the
same multi-plan problem but pays for it with an extra click to see any
one plan's dependents — overhead that isn't worth it at the
one-to-three plans an employee realistically carries; that tradeoff
only starts to pay off once plan history piles up, which isn't the
common case here. Repeatable cards scale from zero to a few enrollments
without a layout change, and everything stays visible without a click,
matching the same "asking around" avoidance already applied on
Employee Detail's own Profile tab.

HTML mockup: [[../ux-pages/employee-benefits.html]]
