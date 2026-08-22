---
title: loan-ledger-flat-table-edit-drawer
tags: [hris, design, ux, company, admin, payroll]
date: 2026-08-22
---

Chose "Flat table + edit drawer" for the Loan Ledger tab content on
[[employee-detail-inline-edit-with-reserved-tabs|Employee Detail]] —
one master table row per loan, editing opens a right-side drawer — over
"Repeatable progress cards" (one editable card per loan, mirroring
Benefits) and "Compact list, paid-off collapsed" (expandable rows,
settled loans tucked behind a toggle). Full comparison, all three built
on the same tokens:
https://claude.ai/code/artifact/0ca708e3-de0a-42af-b19d-6e8149868058

**Layout — the chosen option:**
- "Loan Ledger" section holds a single table, one row per loan
  (zero-to-many — an employee can carry an SSS Salary Loan alongside a
  Pag-IBIG loan and a company loan at once): Loan type, Total amount,
  Monthly amortization, Remaining installments, a progress bar, and a
  status badge, plus a pencil per row.
- Editing a row opens the same right-side slide-over drawer already
  used for Payroll Run Detail's line-item adjustments, Time &
  Attendance's shift templates, and Rate Tables' agency editing — the
  fourth reuse of that mechanic. "+ Add loan" opens the identical
  drawer blank.
- Fields: loan type (select), total amount, monthly amortization
  (typed in from the loan statement, never computed, per
  [[../statutory-deductions-as-editable-data-not-code]]'s same
  reasoning), and remaining installments. The "X% paid" progress shown
  is computed on the fly from those three fields — not a new persisted
  column.
- Status badge reuses [[badge-system-four-categories]]'s existing
  mapping: Active → Neutral, Paid off → Positive. A paid-off row stays
  in the table (dimmed, not hidden) rather than disappearing, since
  it's still a real record.
- Zero-state uses the [[empty-states-guided]] shape (icon + headline +
  subtext + "+ Add loan" CTA).

Built on tokens already decided elsewhere:
[[color-palette-ink-and-amber|Ink & Amber]] palette,
[[type-system-neutral-and-efficient|Archivo/Work Sans/IBM Plex Mono]]
type, [[data-tables-comfortable-density|comfortable-density tables]],
and the same identity-strip/section/drawer components already built for
[[employee-detail-inline-edit-with-reserved-tabs|Employee Detail]] and
[[rate-tables-landing-cards-edit-drawer|Rate Tables]].

**Carried over, not re-decided here:** scope is exactly
[[../cash-advance-vs-loan-ledger-distinction|the loan ledger's own
scope]] — loan type, total amount, monthly amortization, remaining
installments; auto-adds as a deduction each payroll run, counts down,
marks itself paid off at zero. No interest computation, no loan
application/approval workflow, no early payoff/refinancing. Cash
advances are explicitly out of scope here — they stay a manual payroll
deduction line, per the same decision.

Why this one: Loan Ledger's data is ledger-shaped — running balances
and payoff counts that read best lined up in columns for direct
comparison across an employee's loans — closer to Rate Tables or
Payroll Run Detail than to Benefits' more profile-shaped fields.
Repeatable Progress Cards (Benefits' own chosen pattern) would have
been the consistency pick, but it costs more vertical scroll once an
employee carries several loans, and doesn't add anything a table column
doesn't already show. Compact List solves the same scan problem but
only pays for its extra collapse/expand interaction once paid-off loans
actually pile up over a long tenure — not the common case. The flat
table's real strength is reusing, for the fourth time, the exact drawer
mechanic already established on Payroll Run Detail, Time & Attendance,
and Rate Tables — at this point it's the established way HR opens an
editable record in this app, so a new employee-facing pattern isn't
being introduced just for this one screen.

HTML mockup: [[../ux-pages/employee-loan-ledger.html]]
