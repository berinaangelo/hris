---
title: my-payslips-pinned-hero-swappable-table
tags: [hris, design, ux, payslips, payroll]
date: 2026-08-21
---

Chose "Pinned Hero + Swappable Table" for the v1 My Payslips page — the
employee's read-only payslip history, under Me → My Payslips (see
[[navigation-me-team-company]]) — a full breakdown of the latest payslip
always pinned above the fold, with a full history table below that
swaps the pinned panel on click — over "Table + Modal, Year Filter" (a
year-filtered table with a shared modal for detail) and "Statement Feed
by Year" (bank-statement-style rows, expandable inline, grouped by
year). Full comparison, all three built on the same tokens:
https://claude.ai/code/artifact/ffc33516-ab44-43a6-8fbc-1ca282543c1c

**Layout:**
- Top: the latest payslip's full breakdown — earnings, statutory
  deductions, net pay, a Download action — visible with zero clicks,
  the same instant-surfacing already used for balance on
  [[time-off-list-plus-modal|Time Off]] and the current rating on
  [[my-reviews-split-master-detail|My Reviews]].
- Below: the full cutoff history as a comfortable-density table
  (period, pay date, type, gross, net); clicking a row swaps the pinned
  panel to that cutoff's breakdown instead of opening anything new.
- No modal, no year filter needed as a separate control — scanning past
  cutoffs and opening one are the same table.

Built on tokens already decided elsewhere:
[[color-palette-ink-and-amber|Ink & Amber]] palette,
[[type-system-neutral-and-efficient|Archivo/Work Sans/IBM Plex Mono]]
type, [[badge-system-four-categories|four-category badges]] (used only
for the non-default "13th Month" entry type), and
[[data-tables-comfortable-density|comfortable table density]] for the
history list.

**Carried over, not re-decided here:** built ahead of payroll v2's own
commitment (v2 is scoped and committed, but deferred until v1 ships —
see [[../../projects/hris/features/payroll-v2/PLAN.md]]), the same
reasoning as building My Reviews ahead of its backlog status. Figures
shown are illustrative placeholders, not real rate-table output — real
amounts come from
[[statutory-deductions-as-editable-data-not-code|editable statutory
tables]]; the loan line reflects the typed-in amortization from
[[cash-advance-vs-loan-ledger-distinction]]; the December entry
reflects [[thirteenth-month-pay-mandatory-in-ph]].

Why this one: matches the pattern already set on the other two
history-plus-detail Me-tab screens — surface the one current fact
first, let history be secondary. Here that fact is "what did I just get
paid," arguably the single most-asked question on this page, so it gets
answered before any scrolling or clicking. Swapping the pinned panel
from a table row is also just one click, same cost as opening a modal,
but without a dialog component to build or an overlay to manage.

Table + Modal was the cheapest build — reuses the exact modal already
shipped three times over (My Profile, Time Off, My Reviews) — but
starts every visit on an empty history table with nothing surfaced,
and needed its own extra control (the year filter) just to stay usable
once a year of cutoffs piles up, a cost this option avoids since the
table's own row-click already does double duty as both filter-by-scroll
and open. Statement Feed read best on a phone and needed no separate
detail area at all, but costs the most ongoing build effort — every row
eventually wants its own expand affordance — and it's the one of the
three that doesn't keep "what did I get paid" as a fixed, unscrolled
answer.

HTML mockup: [[../ux-pages/my-payslips.html]]
