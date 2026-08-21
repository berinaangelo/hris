---
title: statutory-deductions-as-editable-data-not-code
tags: [hris, payroll, ruthless-simplicity, philippines]
date: 2026-08-21
---

For [[../projects/hris/features/payroll-v2/PLAN.md|payroll v2]], SSS,
PhilHealth, Pag-IBIG, and BIR withholding tax are all stored as
admin-editable rate/bracket tables — never hardcoded computation logic.

Why: these aren't fixed formulas, they're regulatory tables the
Philippine government revises on its own schedule (SSS revised its
bracket table in 2023; PhilHealth's premium rate has a legislated
yearly step-up through 2025; Pag-IBIG's rate/cap gets revised too; BIR
uses the TRAIN law's progressive brackets). Hardcoding the computation
means an engineer has to ship a deploy every time an agency updates a
table — a maintenance liability disguised as a feature.

Instead: HR (or whoever maintains the account) updates the table when
government publishes a new one; the app just looks up income → deduction.
No redeploy needed when rates change, no engineer required to keep it
compliant.

This is the same principle applied twice more in the same feature:
- [[thirteenth-month-pay-mandatory-in-ph]] — a company-level toggle +
  trivial formula, not a maintained bracket table, since the 13th month
  formula itself doesn't change (only whether it applies)
- [[cash-advance-vs-loan-ledger-distinction]] — loan amortization amounts
  are typed in from the loan/agency statement, never computed
  (no interest calculation built in-house)

See [[ph-hr-payroll-compliance-glossary]] for what each of these
deductions actually is.
