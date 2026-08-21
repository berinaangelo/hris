# Payroll — Plan

Status: v2 — committed, scoped, deferred until after v1 (MVP) ships
Last updated: 2026-08-21

## One-sentence description

Payroll takes each employee's salary plus manual adjustments and active
loan deductions, applies statutory contributions and tax using editable
rate tables, and produces a payslip per cutoff.

## Core flow

1. HR opens a pay period.
2. Pulls base salary per employee (from the employee profile).
3. Adds manual line items (bonus, deduction, cash advance repayment, OT).
4. Active loans auto-add their monthly amortization.
5. System looks up SSS/PhilHealth/Pag-IBIG/BIR withholding from editable
   rate tables.
6. Computes net pay, generates a payslip.
7. Employee views/downloads it.

## In scope

- Base salary (from employee profile)
- Single pay period/cutoff schedule (semi-monthly, PH standard)
- Manual adjustment line items — bonus, deduction, cash advance
  repayment, OT (see [[cash-advance-vs-loan-ledger-distinction]])
- Loan ledger — `loan_type` (SSS / Pag-IBIG / Company), `total_amount`,
  `monthly_amortization` (typed in, not computed), `remaining_
  installments`; auto-adds as a deduction each payroll run, counts down,
  marks paid off at zero (see [[cash-advance-vs-loan-ledger-distinction]])
- Statutory deductions via editable rate tables: SSS, PhilHealth,
  Pag-IBIG, BIR withholding (see
  [[statutory-deductions-as-editable-data-not-code]])
- Net pay calculation (gross − all deductions)
- Payslip record per employee per cutoff
- Payroll run history (read-only after finalized)
- 13th month pay — company-level toggle
  (`thirteenth_month_pay_enabled`, default true), prorated (÷12),
  flagged for the Dec 24 deadline (see
  [[thirteenth-month-pay-mandatory-in-ph]])

## Out of scope (v2)

- Remittance/filing to SSS/PhilHealth/Pag-IBIG/BIR — compliance/legal
  process, stays manual or a future integration (see
  [[ph-hr-payroll-compliance-glossary]])
- Time & attendance auto-feed into OT/hours
- Multiple pay schedules, currencies, or per-employee cutoffs
- Payroll approval workflow (finance sign-off)
- Direct deposit/bank file generation
- Loan interest computation, loan application/approval workflow, early
  payoff/refinancing
- Self-service cash advance request + auto-tracking — still just a
  manual deduction line item for now (see
  [[cash-advance-vs-loan-ledger-distinction]])

## Related decisions

- [[statutory-deductions-as-editable-data-not-code]]
- [[cash-advance-vs-loan-ledger-distinction]]
- [[thirteenth-month-pay-mandatory-in-ph]]
