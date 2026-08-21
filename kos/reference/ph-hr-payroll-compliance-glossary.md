---
title: ph-hr-payroll-compliance-glossary
tags: [hris, philippines, payroll, compliance, glossary]
date: 2026-08-21
---

Glossary of Philippine HR/payroll compliance terms that came up scoping
[[../projects/hris/PLAN.md|the HRIS project]]. Reference only — not legal
advice.

- **SSS (Social Security System)** — government retirement/disability/
  sickness fund. Employer deducts a contribution per a bracket table that
  maps income ranges to a fixed EE/ER split. Table is revised periodically
  by law (last revised 2023) — see
  [[statutory-deductions-as-editable-data-not-code]] for why this must be
  stored as editable data, not hardcoded logic.
- **PhilHealth** — government health insurance premium. Percentage of
  salary with a floor/ceiling; the percentage has a legislated step-up
  schedule through 2025. Same "editable table" treatment as SSS.
- **Pag-IBIG (HDMF)** — government housing fund. Percentage-based
  contribution with a cap; rate/cap revised periodically. Same treatment.
- **BIR withholding tax** — income tax withheld each payroll cutoff,
  computed off a progressive bracket table (TRAIN law brackets). Same
  "editable table" treatment as the three above.
- **13th month pay (PD 851)** — legally mandated for rank-and-file private
  sector employees, due by December 24 each year. Formula: total basic
  salary earned in the year ÷ 12 (prorated if less than a full year
  worked). Narrow exemptions: managerial employees are excluded from the
  mandate, or the employer already pays an equivalent/greater benefit.
  See [[thirteenth-month-pay-mandatory-in-ph]].
- **Remittance/filing** — separately from computing the deduction, the
  employer must actually submit contribution reports and pay SSS/
  PhilHealth/Pag-IBIG/BIR by their deadlines. This is a compliance/legal
  filing process, not a math problem — kept out of scope for the HRIS
  (manual or a future integration with a licensed PH payroll provider),
  see [[../projects/hris/features/payroll-v2/PLAN.md|payroll v2 scope]].
- **DOLE SEnA (Single Entry Approach)** — free mediation step an employee
  can file through DOLE for a labor complaint (e.g. unpaid 13th month
  pay) before a formal case, even after leaving the employer.
- **PIP (Performance Improvement Plan) due process** — termination
  following a failed PIP has specific documentation/notice requirements
  under PH labor law (the "twin notice rule"). The HRIS records PIP
  cycles and outcomes but never automates any consequence of a PIP
  outcome — see
  [[../projects/hris/features/performance-reviews-goals/PLAN.md|performance reviews scope]].
