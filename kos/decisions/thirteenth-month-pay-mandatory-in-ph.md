---
title: thirteenth-month-pay-mandatory-in-ph
tags: [hris, payroll, philippines, compliance]
date: 2026-08-21
---

13th month pay is included in
[[../projects/hris/features/payroll-v2/PLAN.md|payroll v2]] core scope
(not deferred), because it's legally mandated in the Philippines for
rank-and-file private-sector employees (PD 851), not merely a company
preference — see [[ph-hr-payroll-compliance-glossary]].

Narrow legal exemptions: managerial employees are excluded from the
mandate, or the employer already pays an equivalent/greater benefit
under another name — it is not something a typical PH company can
opt out of for rank-and-file staff.

Implementation: company-level toggle `thirteenth_month_pay_enabled`
(default **true**), since the toggle still needs to exist for companies
outside the mandate's scope (non-PH deployment, or a workforce that's
entirely managerial) — modeling per-employee exemption by classification
was deliberately left out as over-engineering for v2. Formula is the
trivial one: total basic salary earned in the year ÷ 12, prorated;
flagged for the December 24 legal deadline.
