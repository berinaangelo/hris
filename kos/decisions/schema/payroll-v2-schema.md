---
title: payroll-v2-schema
tags: [hris, schema, database, payroll-v2]
date: 2026-08-23
---

DB schema for [[../../projects/hris/features/payroll-v2/PLAN.md|Payroll
v2]]. Depends on [[core-v1-schema]] (`companies`, `employees`). Companion:
[[basic-reporting-schema]] documents why Payroll Register/Statutory
Contributions Summary need no new tables of their own.

## companies — one added column

`thirteenth_month_pay_enabled`, boolean, not null, default `true` — per
[[../thirteenth-month-pay-mandatory-in-ph]]. Same "just a toggle on
companies" treatment as the two attendance toggles in
[[core-v1-schema]] — still only a third boolean total, not yet worth a
settings table.

**Deliberately NOT modeled:** Overtime Rules (multipliers) and
Deduction Defaults (cap, categories) from
[[../ui/payroll-settings-parked-overtime-deduction-defaults]] — that
doc is explicit these are disabled placeholder fields, "nothing here is
wired to any state or persisted." No columns added until payroll scope
actually expands to compute OT/deductions automatically; today both
stay manual per-run line items.

**Not a table:** Pay Schedule (semi-monthly) is "Fixed for v2" per the
same settings screen — a hardcoded assumption in code, not
company-configurable data, so no `pay_schedules` table.

## loans

The loan ledger from
[[../cash-advance-vs-loan-ledger-distinction]] — cash advances stay a
manual `payslip_line_items` row (see below), never their own table.

| Column | Type | Notes |
|---|---|---|
| employee_id | bigint, FK, not null | |
| loan_type | integer (enum: sss_salary_loan, pagibig_mpl, pagibig_calamity, company_loan), not null | |
| total_amount | decimal(12,2), not null | |
| monthly_amortization | decimal(10,2), not null | typed in from the loan statement, never computed |
| remaining_installments | integer, not null | counts down each payroll run |
| status | integer (enum: active, paid_off), not null, default `0` | set by the payroll-run interactor when `remaining_installments` hits 0 — not a live-computed column, so a paid-off loan's badge doesn't depend on being re-derived on every read |

**Indexes**
- `employee_id`
- `[employee_id, status]` — "active loans auto-add" is exactly this
  filter, run once per employee per payroll run

## rate_tables

SSS/PhilHealth/Pag-IBIG/BIR withholding, per
[[../statutory-deductions-as-editable-data-not-code]]. One current row
per agency per company — **no effective-dated version history**, an
edit replaces the table outright, per
[[../ui/rate-tables-landing-cards-edit-drawer]]'s own explicit scope
("editing here would only affect future payroll runs' lookups, never
recompute already-finalized payslips" — safe precisely because a
finalized payslip's line items are already snapshotted into
`payslip_line_items`, not re-derived from `rate_tables` after the fact).

Each agency's content is a different shape (SSS/BIR are bracket
tables, PhilHealth is flat rate fields, Pag-IBIG is a 2-row bracket
plus a cap field) — modeled as two JSON columns rather than forcing a
uniform relational shape, since nothing ever joins/aggregates across
individual bracket rows; the whole table is read as one lookup blob at
payslip-generation time.

| Column | Type | Notes |
|---|---|---|
| company_id | bigint, FK, not null | |
| agency | integer (enum: sss, philhealth, pagibig, bir), not null | |
| effective_date | date, not null | |
| brackets | json, nullable | array of `{min, max, employee_share, employer_share, base_amount, percent_over_excess}` — SSS/BIR/Pag-IBIG's bracket rows; null for PhilHealth |
| fields | json, nullable | flat `{key: value}` — PhilHealth's rate %, Pag-IBIG's compensation cap; null for pure-bracket agencies |
| updated_by_id | bigint, FK → employees, nullable | |

**Indexes**
- unique `[company_id, agency]` — the "one current table per agency,
  replaced outright" rule enforced at the DB, not just app logic

## payroll_runs

| Column | Type | Notes |
|---|---|---|
| company_id | bigint, FK, not null | |
| period_start | date, not null | |
| period_end | date, not null | |
| pay_date | date, not null | |
| run_type | integer (enum: regular, thirteenth_month), not null, default `0` | Dec 24 run is a normal row, just flagged by type, per [[../thirteenth-month-pay-mandatory-in-ph]] |
| status | integer (enum: open, finalized), not null, default `0` | |
| finalized_at | datetime, nullable | |
| finalized_by_id | bigint, FK → employees, nullable | |

```ruby
# "Only one run can be open at a time — a real business rule, not a UI
# choice" (payroll-runs-pinned-open-run.md). MySQL has no partial/
# filtered unique index, so this is enforced in
# Payroll::OpenRun (validates no existing status: :open row for the
# company before creating one), not a DB constraint.
```

Finalizing uses **pessimistic locking + idempotency**
(`payroll_run.with_lock`), per
[[../rails-db-transactions-locking-idempotency]] — a double-click can't
double-process. No `lock_version` column needed for that; pessimistic
locking is a row lock at finalize time, not optimistic conflict
detection.

**Indexes**
- `company_id`
- `[company_id, status]`

## payslips

Supports Void & Reissue as a version chain, not a separate audit-log
table — `previous_version_id` self-references the voided payslip it
replaces, matching
[[../ui/payslip-detail-admin-breakdown-audit-rail]]'s "Correction
history" timeline, which is just this chain rendered.

| Column | Type | Notes |
|---|---|---|
| payroll_run_id | bigint, FK, not null | |
| employee_id | bigint, FK, not null | |
| status | integer (enum: draft, finalized, voided), not null, default `0` | |
| gross_pay | decimal(10,2), not null, default `0` | stored, not recomputed live — a finalized cutoff's figures are locked |
| total_deductions | decimal(10,2), not null, default `0` | |
| net_pay | decimal(10,2), not null, default `0` | |
| previous_version_id | bigint, FK → payslips, nullable | set on the new payslip created by Void & Reissue; the row it points to gets `status: voided` |
| void_reason | text, nullable | required by the Void & Reissue modal when voiding, per that decision |
| generated_at | datetime, nullable | |
| generated_by_id | bigint, FK → employees, nullable | |
| emailed_at | datetime, nullable | Delivery card |
| viewed_at | datetime, nullable | employee opened it — Delivery card's "viewed" badge |

**Indexes**
- `[payroll_run_id, employee_id]`
- `status`
- `previous_version_id`

## payslip_line_items

One row per earning/deduction — base salary, manual adjustments
(bonus/OT/cash advance/deduction), auto-added loan amortization, and
the four statutory withholdings all live here, distinguished by
`line_type`/`source` rather than four separate tables, since Payroll
Run Detail's Adjustments/Loan/Statutory sections are just filtered
views of the same shape.

| Column | Type | Notes |
|---|---|---|
| payslip_id | bigint, FK, not null | |
| line_type | integer (enum: base_salary, bonus, overtime, cash_advance, other_deduction, loan_repayment, statutory_sss, statutory_philhealth, statutory_pagibig, statutory_bir), not null | |
| direction | integer (enum: earning, deduction), not null | `gross_pay`/`total_deductions` are just `SUM` by direction |
| source | integer (enum: base, manual, loan, statutory), not null | provenance — base salary pulled from the profile, manual = HR-typed adjustment, loan = auto-added, statutory = rate-table lookup |
| loan_id | bigint, FK → loans, nullable | set when `source: loan` — which loan generated this deduction, so the payroll-run interactor can decrement `remaining_installments` |
| description | string, nullable | |
| amount | decimal(10,2), not null | always positive; `direction` carries the sign meaning |

**Indexes**
- `payslip_id`
- `loan_id`

## Rollup mechanics — none needed; see [[basic-reporting-schema]]

Payroll Register and Statutory Contributions Summary
([[../../projects/hris/features/basic-reporting/PLAN.md|basic-reporting]])
both read straight off `payslips`/`payslip_line_items` with a `GROUP
BY`/`SUM` scoped to one `payroll_run_id` or date range — at SME
headcount (tens to low hundreds of employees per cutoff) that's a
trivial indexed aggregate, not a rollup candidate. Full reasoning in
[[basic-reporting-schema]].

## Related decisions

- [[../../projects/hris/features/payroll-v2/PLAN.md]]
- [[../cash-advance-vs-loan-ledger-distinction]]
- [[../thirteenth-month-pay-mandatory-in-ph]]
- [[../statutory-deductions-as-editable-data-not-code]]
- [[../rails-db-transactions-locking-idempotency]]
- [[core-v1-schema]]
