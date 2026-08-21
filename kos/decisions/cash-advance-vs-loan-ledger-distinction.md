---
title: cash-advance-vs-loan-ledger-distinction
tags: [hris, payroll, scope]
date: 2026-08-21
---

Within [[../projects/hris/features/payroll-v2/PLAN.md|payroll v2]], cash
advances and loans get different treatment despite being mechanically
similar (both are "employee owes money, deducted from future payroll
until paid off").

**Cash advance** — stays a manual deduction line item, typed in by HR
each cutoff. No dedicated request/approval/balance-tracking module.
Reasoning: it's already fully covered by the existing "manual adjustment
line item" payroll mechanic, and cash advances are typically short-term
(one or a few repayment cycles), so the risk of HR forgetting or
mis-entering it is low. A full self-service request+approval+
auto-installment feature (same shape as the leave-request flow) is a
legitimate v3 candidate, but only once HR is observed re-entering the
same deduction repeatedly — that's the real signal it's worth
automating, not a guess upfront.

**Loans (SSS Salary Loan, Pag-IBIG MPL/Calamity Loan, company loans)** —
get a lightweight ledger: `loan_type`, `total_amount`,
`monthly_amortization` (typed in from the loan statement, never
computed — see
[[statutory-deductions-as-editable-data-not-code]]), `remaining_
installments`. Auto-adds as a deduction each payroll run, counts down,
marks itself paid off at zero.

Reasoning for the different treatment: loans run for a long time (SSS
Salary Loan ≈ 24 months), so manual re-entry every cutoff is where real
error shows up — a missed cutoff or wrong amount compounds over 2 years.
Government-routed loans also carry a remittance obligation to the
agency, raising the cost of a wrong deduction. Explicitly out of scope
even for the ledger: interest computation, loan application/approval
workflow, early payoff/refinancing.
