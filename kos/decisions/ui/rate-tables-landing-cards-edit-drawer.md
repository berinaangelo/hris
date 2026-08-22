---
title: rate-tables-landing-cards-edit-drawer
tags: [hris, design, ux, company, admin, payroll]
date: 2026-08-22
---

Chose "Landing cards + edit drawer" for Rate Tables — the HR-Admin screen
under Company → Payroll → Rate Tables where SSS/PhilHealth/Pag-IBIG/BIR
withholding are stored as admin-editable data
([[../statutory-deductions-as-editable-data-not-code.md]]), the "separate
not-yet-built page" referenced from
[[payroll-run-detail-master-table-edit-drawer|Payroll Run Detail]]'s
read-only statutory section — over "Agency tabs, inline edit" (a
segmented switcher showing one full-width table at a time) and "Stacked
sections, accordion" (all four agencies on one scroll). Full comparison,
same four agencies and figures on identical tokens:
https://claude.ai/code/artifact/7ccfceb0-a103-4329-b48b-a7874df285bb

**Layout — the chosen option:**
- A landing dashboard: a stat strip (4 statutory tables, how many
  updated within the last year, oldest update) above a 2×2 grid of
  agency cards (SSS, PhilHealth, Pag-IBIG, BIR) — each showing effective
  date, "updated by X · relative time," a content count (bracket count
  or field count), and a caution badge — "Not reviewed in over a
  year" — on any table not touched in 12+ months, per
  [[badge-system-four-categories]]'s "badges are for deviation" rule.
- "Edit rates" on a card opens a right-side slide-over drawer scoped to
  that one agency, reusing the exact drawer mechanic already shipped on
  [[payroll-run-detail-master-table-edit-drawer|Payroll Run Detail]] and
  [[time-attendance-attendance-first-templates-drawer|Time &
  Attendance]]. Unlike those two, the drawer here has no separate
  view/edit toggle — opening it is already the deliberate "I'm here to
  edit" action, so its bracket-table rows and rate fields are directly
  editable inputs, with "+ Add bracket" and a per-row delete, plus a
  Cancel/Save footer.
- SSS and BIR render as true multi-row bracket tables (range → amounts,
  or range → base tax + % over excess); PhilHealth is a handful of rate
  fields (no bracket structure); Pag-IBIG is a 2-row bracket table plus
  a separate compensation cap field — content shape follows what each
  agency's table actually is, not a forced-uniform grid.

Built on tokens already decided elsewhere:
[[color-palette-ink-and-amber|Ink & Amber]] palette,
[[type-system-neutral-and-efficient|Archivo/Work Sans/IBM Plex Mono]]
type, [[badge-system-four-categories|four-category badges]], and the
drawer/scrim mechanic reused verbatim a third time now.

**Carried over, not re-decided here:** rates shown are illustrative only
(approximate recent public bracket shapes, not verified against current
circulars) — real data entry happens once this ships. No live
computation is wired — editing a value here doesn't recompute anything
in this mockup. No effective-dated version history — an edit replaces
the current table outright, consistent with payroll v2's own "no
computed history, only current lookups" scope
([[../projects/hris/features/payroll-v2/PLAN.md]]). Editing here would
only affect future payroll runs' lookups, never recompute
already-finalized payslips.

Why this one: this screen is visited rarely — only when an agency
publishes a revised table, maybe once a year or less per agency — so
the god-moment worth optimizing for is "which of these four is stale
and needs a look," not fast browsing of current figures on a screen
nobody scans often. The landing cards answer that in one glance (the
"Agency tabs" option buries last-updated behind a click per agency; the
"Accordion" option surfaces it but competes for width against wide
bracket tables in the same collapsed rail). Editing statutory data also
benefits from a deliberately separated, focused surface rather than an
always-live inline table on a page someone might just be browsing —
same reasoning already applied to
[[payroll-run-detail-master-table-edit-drawer|Payroll Run Detail's]]
drawer, now without even a view/edit toggle since opening the drawer
already signals intent to edit.

HTML mockup: [[../ux-pages/rate-tables.html]]
