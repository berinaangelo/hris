# Knowledge Base Index

Last updated: 2026-08-21

One line per note/project, link + why-it-exists, mirroring the folder
structure below. Read this first; open only the files you actually need.

## Projects
- [hris](projects/hris/PLAN.md) — Philippine SME HR system: employee
  records + leave (v1), payroll (v2), and five scoped-but-uncommitted
  post-MVP features
  - [payroll-v2](projects/hris/features/payroll-v2/PLAN.md) — v2,
    committed
  - [performance-reviews-goals](projects/hris/features/performance-reviews-goals/PLAN.md)
    — post-MVP backlog
  - [basic-reporting](projects/hris/features/basic-reporting/PLAN.md) —
    post-MVP backlog
  - [compliance-certification-tracking](projects/hris/features/compliance-certification-tracking/PLAN.md)
    — post-MVP backlog, customer-dependent
  - [recruitment-ats](projects/hris/features/recruitment-ats/PLAN.md) —
    post-MVP backlog
  - [benefits](projects/hris/features/benefits/PLAN.md) — post-MVP
    backlog, record-keeping only
  - [time-attendance](projects/hris/features/time-attendance/PLAN.md) —
    post-MVP backlog, customer-dependent, configurable shift templates

## Decisions
- [tech-stack-hotwire-over-coffeescript](decisions/tech-stack-hotwire-over-coffeescript.md)
  — Turbo+Stimulus over legacy CoffeeScript/Sprockets
- [statutory-deductions-as-editable-data-not-code](decisions/statutory-deductions-as-editable-data-not-code.md)
  — SSS/PhilHealth/Pag-IBIG/BIR rate tables stored as admin-editable
  data, never hardcoded formulas
- [vendor-fragmented-features-record-keeping-only](decisions/vendor-fragmented-features-record-keeping-only.md)
  — benefits (and similar vendor-fragmented workflows) get a
  record-keeping field, not a built workflow
- [approval-chains-scrapped-fallback-design](decisions/approval-chains-scrapped-fallback-design.md)
  — multi-step approvals scrapped for v1; capped-at-two-step design
  documented for if a real customer needs it
- [cash-advance-vs-loan-ledger-distinction](decisions/cash-advance-vs-loan-ledger-distinction.md)
  — cash advance stays a manual payroll deduction line; loans get a
  lightweight auto-deducting ledger
- [thirteenth-month-pay-mandatory-in-ph](decisions/thirteenth-month-pay-mandatory-in-ph.md)
  — legally mandated for PH rank-and-file employees (PD 851); included
  in payroll v2 with a company toggle
- [ats-checker-reuse-parked-for-recruitment](decisions/ats-checker-reuse-parked-for-recruitment.md)
  — existing resume-scoring tool reusable later, doesn't pull
  recruitment/ATS into scope now
- [performance-review-kpi-based-not-form-builder](decisions/performance-review-kpi-based-not-form-builder.md)
  — fixed KPI structure with free-text content, instead of a
  configurable evaluation form builder
- [color-palette-ink-and-amber](decisions/color-palette-ink-and-amber.md)
  — navy + burnt-orange complementary palette, chosen over two other
  proposed options; Bulma variable mapping included
- [type-system-neutral-and-efficient](decisions/type-system-neutral-and-efficient.md)
  — Archivo + Work Sans neo-grotesque pairing, chosen over two other
  proposed options; IBM Plex Mono fixed for all numerals
- [badge-system-four-categories](decisions/badge-system-four-categories.md)
  — positive/caution/negative/neutral status pills mapped across every
  feature; badges omitted for default/steady states
- [navigation-me-team-company](decisions/navigation-me-team-company.md)
  — top-level Me/Team/Company switcher, chosen over a unified sidebar
  and a dashboard-first pattern; scales as backlog features land
- [empty-states-guided](decisions/empty-states-guided.md) — icon +
  headline + conditional CTA, chosen over a minimal and a
  contextual-with-help-links option; contextual deferred post-v2
- [form-validation-inline-only](decisions/form-validation-inline-only.md)
  — per-field inline errors on submit, with an auto-summary flex rule
  at 3+ errors; live blur validation set aside per the Hotwire decision
- [notifications-nav-badge-counts](decisions/notifications-nav-badge-counts.md)
  — live pending-count badges on Me/Team/Company tabs for MVP; no new
  table, notification center deferred post-MVP
- [spacing-bulma-default](decisions/spacing-bulma-default.md) —
  reuses Bulma's built-in `$spacing-values` helper classes as-is, no
  custom scale
- [dark-mode-deferred-tokenize-colors-now](decisions/dark-mode-deferred-tokenize-colors-now.md)
  — dark mode out of v1, but colors implemented as Sass/CSS tokens from
  the start so it's cheap to add later

## Reference
- [ph-hr-payroll-compliance-glossary](reference/ph-hr-payroll-compliance-glossary.md)
  — SSS/PhilHealth/Pag-IBIG/BIR/13th-month/DOLE basics relevant to this
  project

## People

(none yet)
