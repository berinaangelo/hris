---
title: payroll-run-detail-master-table-edit-drawer
tags: [hris, design, ux, company, admin, payroll]
date: 2026-08-22
---

Chose "Master table + edit drawer" for Payroll Run Detail — the
HR-Admin screen an admin lands on after clicking into a run from
[[../ux-pages/payroll-runs.html|Payroll Runs]], covering line items per
employee and the run/finalize action from
[[../projects/hris/features/payroll-v2/PLAN.md|payroll v2]]'s step 6 —
over a "Flat table + expandable row detail" option (accordion, one row
at a time) and a "Roster + editable split detail" option (permanent
two-column master-detail). Full comparison, same open Aug 16–31, 2026
run and 10 employees on identical tokens:
https://claude.ai/code/artifact/39228f4e-bc00-464b-9a57-40c877954e06

**Layout — the chosen option:**
- Run header: breadcrumb back to Payroll Runs, period + Open badge, pay
  date/employee count, Export and Finalize payroll run actions.
- A stat strip (Employees, Gross so far*, loan deductions auto-added,
  Missing OT count) plus a caution flag card naming the employees still
  missing OT entries — reused from
  [[../ux-pages/payroll-runs.html|Payroll Runs]]' pinned-open-run hero
  flag treatment (that page's own three options are built but not yet
  decided between).
- Master `<table>` stays the permanent source of truth — Employee, base
  salary, adjustments, loan, statutory total, net pay, status — same
  [[data-tables-comfortable-density|comfortable density]] as every
  other HRIS table.
- Each row's "Edit" opens a right-side slide-over drawer scoped to that
  one employee: an editable Adjustments section (bonus/OT/deduction/
  cash advance line items, "+ Add line item"), a read-only Loan section
  (auto-added from the loan ledger,
  [[../decisions/cash-advance-vs-loan-ledger-distinction.md|loan vs
  cash-advance distinction]]), a read-only Statutory section (SSS/
  PhilHealth/Pag-IBIG/BIR, looked up from editable rate tables — a
  separate not-yet-built page,
  [[../decisions/statutory-deductions-as-editable-data-not-code.md|data-not-code]]),
  and a computed net pay total. The table stays visible and scrollable
  behind the drawer's scrim.
- Finalize payroll run opens a modal. In this run's state (3 employees
  missing OT) it shows a blocked message naming them rather than a
  confirm step — there is no approval workflow
  ([[../decisions/approval-chains-scrapped-fallback-design.md]]), the
  same HR Admin who ran payroll finalizes directly once every employee
  is resolved; finalizing itself uses pessimistic locking + idempotency
  so a double-click can't double-process
  ([[../decisions/rails-db-transactions-locking-idempotency.md]]).
- Status carries a badge only for the deviation case — Missing OT
  (Caution); a resolved/ready row shows no badge, per
  [[badge-system-four-categories]]'s "badges are for deviation" rule.

Built on tokens already decided elsewhere:
[[color-palette-ink-and-amber|Ink & Amber]] palette,
[[type-system-neutral-and-efficient|Archivo/Work Sans/IBM Plex Mono]]
type, [[data-tables-comfortable-density|comfortable table density]],
and the drawer mechanic itself is reused verbatim from
[[time-attendance-attendance-first-templates-drawer|Time & Attendance's
templates drawer]] — same slide-over-with-scrim pattern, now scoped per
row instead of per screen-section.

**Carried over, not re-decided here:** base salary comes from the
employee profile; cash advances stay a manual deduction line item, no
dedicated request/approval module
([[../decisions/cash-advance-vs-loan-ledger-distinction.md]]); rate
tables (SSS/PhilHealth/Pag-IBIG/BIR) are shown read-only here and
edited on their own future page. No live recompute wired in the
mockup — line-item inputs and the resulting net pay are illustrative,
not functional. Drawer shown open here on Mikaela Santos purely for
this comparison; a real visit starts closed.

Why this one: payroll editing is a "fix a handful, glance at the rest"
task most cutoffs, not a screen where every row gets touched — the
drawer keeps that majority path (scan the table, confirm, move on)
cheap, and pays a small open/close cost only on the employees that
actually need a line item changed, without ever losing the admin's
place in the full 42-row list. Same trade-off already made for shift
templates, now applied to a screen with real per-row edit state instead
of a shared settings list. The Flat/expandable option forced scrolling
past finished rows to reach the next flagged one; the Roster/split
option earns its permanent two-column width in a screen visited
repeatedly per cutoff, but Run Detail's real job is scanning all 42 at
once, not stepping through them one by one — that fixed layout cost
wasn't worth it here.

HTML mockup: [[../ux-pages/payroll-run-detail.html]]
