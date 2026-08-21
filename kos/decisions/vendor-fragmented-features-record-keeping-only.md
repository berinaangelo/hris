---
title: vendor-fragmented-features-record-keeping-only
tags: [hris, ruthless-simplicity, scope]
date: 2026-08-21
---

For [[../projects/hris/features/benefits/PLAN.md|benefits administration]],
the HRIS only records the outcome (plan name, provider, effectivity date,
dependents) — it does not build the enrollment workflow, eligibility
rules, cost-sharing computation, or carrier integrations.

Why this class of feature gets record-keeping instead of a built
workflow:
1. **No unified data model** — every HMO/insurance carrier has its own
   enrollment form, plan-tier structure, and dependent rules, mostly with
   no real API. Building this per carrier isn't "one feature," it's N
   integrations.
2. **It's a workflow problem, not a lookup-table problem** — unlike
   statutory deductions (same rule for every company in the country,
   see [[statutory-deductions-as-editable-data-not-code]]), benefits
   eligibility/cost-sharing is specific to each employer's individual
   contract with each carrier. There's no sensible default to ship.
3. **High-stakes failure mode** — a bug in dependent enrollment data can
   mean a denied medical claim, a much heavier correctness bar than most
   of the rest of the app.
4. **Already solved by buy-vs-build** — dedicated benefits-admin
   platforms (Gusto, Zenefits, Rippling in the US) exist specifically
   because this is hard; locally most PH companies still run it manually
   via spreadsheets + an HMO account manager.

Default answer for any future feature with this shape (vendor-fragmented,
workflow-heavy, no standardized interchange): **record the outcome, don't
build the process.** Flagged as the likely fallback if recruitment/ATS
ever needs to touch carrier-style external systems too.
