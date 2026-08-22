# Knowledge Base Index

Last updated: 2026-08-22

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
  — Turbo+Stimulus over legacy CoffeeScript/Sprockets; no Alpine.js, no
  jQuery (DOM reactivity via Stimulus/Turbo Streams, not a client data
  store)
- [rails-thin-controllers-organizer-interactor-pattern](decisions/rails-thin-controllers-organizer-interactor-pattern.md)
  — thin controllers + single-purpose Interactors composed by an
  Organizer, carried over from the user's own past practice, to apply
  once backend implementation starts
- [rails-skinny-models-behavior-in-interactors](decisions/rails-skinny-models-behavior-in-interactors.md)
  — models stay persistence/associations/validations only; behavior
  lives in Interactors/POROs, not the model
- [rails-form-objects-for-multi-model-forms](decisions/rails-form-objects-for-multi-model-forms.md)
  — PORO + ActiveModel::Model for any form touching more than one AR
  model (e.g. Add Employee)
- [rails-query-objects-for-reused-queries](decisions/rails-query-objects-for-reused-queries.md)
  — extract reused or non-trivial `.where` chains into named Query
  Object classes
- [rails-presenters-decorators-for-view-formatting](decisions/rails-presenters-decorators-for-view-formatting.md)
  — view formatting (esp. the badge status→color mapping) lives in a
  Presenter, not duplicated per view
- [rails-pundit-for-authorization](decisions/rails-pundit-for-authorization.md)
  — role-based access goes through Pundit policy classes, not
  scattered role checks
- [rails-activejob-solid-queue-for-background-work](decisions/rails-activejob-solid-queue-for-background-work.md)
  — anything not needed synchronously goes through ActiveJob; adapter
  is Solid Queue (DB-backed, no Redis), not Sidekiq
- [rails-callback-objects-for-cache-busting](decisions/rails-callback-objects-for-cache-busting.md)
  — cache busting via AR callback objects (Laravel-Observer
  equivalent); business-flow side effects stay explicit Interactor
  steps
- [rails-metaprogramming-for-repetitive-methods](decisions/rails-metaprogramming-for-repetitive-methods.md)
  — define_method-driven macros to avoid hand-written near-duplicate
  methods (e.g. per-status predicate/bang pairs), not a blanket style
- [rails-routes-split-into-dedicated-files](decisions/rails-routes-split-into-dedicated-files.md)
  — keep config/routes.rb short, split into config/routes/*.rb via
  `draw` once a section grows
- [code-naming-self-evident-grandma-test](decisions/code-naming-self-evident-grandma-test.md)
  — variable/method/class names must be self-evident at a glance, no
  comment needed to explain them
- [rails-arel-for-complex-queries](decisions/rails-arel-for-complex-queries.md)
  — use Arel once a query outgrows a plain `.where` hash (OR combos,
  date-range overlaps)
- [security-practices-checklist](decisions/security-practices-checklist.md)
  — strong params, no raw SQL, encrypted PII, secrets handling, CSV
  injection guard, Brakeman/bundler-audit in CI
- [rails-orm-performance-n-plus-one-and-indexes](decisions/rails-orm-performance-n-plus-one-and-indexes.md)
  — guard against N+1 queries, missing indexes, and looped saves
- [rails-testing-minitest-factorybot-faker](decisions/rails-testing-minitest-factorybot-faker.md)
  — Minitest, one test type per concern (model/controller/interactor),
  FactoryBot+Faker for test data
- [rails-db-transactions-locking-idempotency](decisions/rails-db-transactions-locking-idempotency.md)
  — transactions via Interactor `.call!` for atomicity, optimistic
  locking on user edits, pessimistic locking + idempotency for payroll
  finalization
- [rails-pagination-and-batch-export-processing](decisions/rails-pagination-and-batch-export-processing.md)
  — sanitized page/page_size params via Pagy, streaming vs
  background-job batching for exports depending on size
- [rails-datatable-pagy-turbo-frame-pattern](decisions/rails-datatable-pagy-turbo-frame-pattern.md)
  — server-rendered tables via Pagy + Turbo Frames + Query Objects, no
  DataTables/Tabulator/Grid.js/AG Grid by default
- [rails-viewcomponent-for-reusable-ui](decisions/rails-viewcomponent-for-reusable-ui.md)
  — component-based views via the ViewComponent gem; admin pages
  render through an enforced `Layouts::AdminComponent` shell instead
  of `content_for` regions
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
- [color-palette-ink-and-amber](decisions/ui/color-palette-ink-and-amber.md)
  — navy + burnt-orange complementary palette, chosen over two other
  proposed options; Bulma variable mapping included
- [type-system-neutral-and-efficient](decisions/type-system-neutral-and-efficient.md)
  — Archivo + Work Sans neo-grotesque pairing, chosen over two other
  proposed options; IBM Plex Mono fixed for all numerals
- [badge-system-four-categories](decisions/ui/badge-system-four-categories.md)
  — positive/caution/negative/neutral status pills mapped across every
  feature; badges omitted for default/steady states
- [navigation-me-team-company](decisions/ui/navigation-me-team-company.md)
  — top-level Me/Team/Company switcher, chosen over a unified sidebar
  and a dashboard-first pattern; scales as backlog features land
- [empty-states-guided](decisions/ui/empty-states-guided.md) — icon +
  headline + conditional CTA, chosen over a minimal and a
  contextual-with-help-links option; contextual deferred post-v2
- [form-validation-inline-only](decisions/ui/form-validation-inline-only.md)
  — per-field inline errors on submit, with an auto-summary flex rule
  at 3+ errors; live blur validation set aside per the Hotwire decision
- [notifications-nav-badge-counts](decisions/ui/notifications-nav-badge-counts.md)
  — live pending-count badges on Me/Team/Company tabs for MVP; no new
  table, notification center deferred post-MVP
- [spacing-bulma-default](decisions/ui/spacing-bulma-default.md) —
  reuses Bulma's built-in `$spacing-values` helper classes as-is, no
  custom scale
- [iconography-lucide](decisions/ui/iconography-lucide.md) — thin
  single-weight icon set, chosen over Heroicons and Phosphor for the
  same "no stylistic opinion" reasoning as the type system
- [motion-functional-microMotion](decisions/ui/motion-functional-microMotion.md)
  — ~180ms confirm-only transitions, chosen over no motion and a full
  spring-eased interaction layer
- [data-tables-comfortable-density](decisions/ui/data-tables-comfortable-density.md)
  — ~46px rows with subtle zebra striping on wide tables, chosen over
  compact and spacious alternatives
- [dark-mode-deferred-tokenize-colors-now](decisions/ui/dark-mode-deferred-tokenize-colors-now.md)
  — dark mode out of v1, but colors implemented as Sass/CSS tokens from
  the start so it's cheap to add later
- [login-page-split-panel](decisions/ui/login-page-split-panel.md) —
  brand panel + form two-column layout, chosen over a centered card and
  a bare-minimum option; god moments used as the left-panel copy;
  mockup at [decisions/ux-pages/login-page.html](decisions/ux-pages/login-page.html)
- [home-dashboard-balance-led-hero](decisions/ui/home-dashboard-balance-led-hero.md)
  — navy hero block leads with leave balance, chosen over a stat-row
  grid and a compact feed; requests list + manager-only approvals nudge
  below; mockup at [decisions/ux-pages/home-dashboard.html](decisions/ux-pages/home-dashboard.html)
- [my-profile-summary-plus-modal](decisions/ui/my-profile-summary-plus-modal.md)
  — read-only summary column + edit-in-a-modal, chosen over a
  whole-page edit toggle and per-section edit cards; HR-owned vs.
  self-managed field split confirmed, not assumed; mockup at
  [decisions/ux-pages/my-profile.html](decisions/ux-pages/my-profile.html)
- [time-off-list-plus-modal](decisions/ui/time-off-list-plus-modal.md) —
  history list as the default view + request form in a modal, chosen
  over an always-on split-panel form and a segmented request/history
  toggle; reuses the My Profile modal pattern; mockup at
  [decisions/ux-pages/time-off.html](decisions/ux-pages/time-off.html)
- [my-reviews-split-master-detail](decisions/ui/my-reviews-split-master-detail.md)
  — persistent cycle rail + detail panel, chosen over a list-with-modal
  and a scrollable accordion timeline; built ahead of the
  performance-reviews-goals feature's own commitment since the nav slot
  is already reserved; mockup at
  [decisions/ux-pages/my-reviews.html](decisions/ux-pages/my-reviews.html)
- [my-payslips-pinned-hero-swappable-table](decisions/ui/my-payslips-pinned-hero-swappable-table.md)
  — latest payslip's full breakdown pinned above a swappable history
  table, chosen over a year-filtered table-with-modal and a
  statement-style feed; built ahead of payroll v2's own commitment;
  mockup at
  [decisions/ux-pages/my-payslips.html](decisions/ux-pages/my-payslips.html)
- [team-approvals-inbox-inline-actions](decisions/ui/team-approvals-inbox-inline-actions.md)
  — flat pending-request list with Approve/Reject directly on each row
  and balance shown inline, chosen over an expand-to-decide card feed
  and a persistent split queue; mirrors the plan's own "one inbox,
  balance inline, one click" wording; mockup at
  [decisions/ux-pages/team-approvals.html](decisions/ux-pages/team-approvals.html)
- [team-calendar-week-agenda](decisions/ui/team-calendar-week-agenda.md)
  — plain day-by-day list for the current week, chosen over a spatial
  month grid and a Gantt-style team row timeline; mirrors the plan's
  "who's out this week is answerable by looking" wording; mockup at
  [decisions/ux-pages/team-calendar.html](decisions/ux-pages/team-calendar.html)
- [team-reviews-split-editable-detail](decisions/ui/team-reviews-split-editable-detail.md)
  — persistent roster rail + editable detail panel, chosen over a
  roster table with row actions and a status-first card grid; the
  manager-authored counterpart to My Reviews, KPI fields editable in
  place rather than in a modal; mockup at
  [decisions/ux-pages/team-reviews.html](decisions/ux-pages/team-reviews.html)
- [people-directory-card-grid-with-list-toggle](decisions/ui/people-directory-card-grid-with-list-toggle.md)
  — photo-forward card grid as the v1 default, chosen over a dense data
  table and department-grouped sections; adds a card/list toggle so the
  table view is always one click away; first Company-tab page; mockup
  at [decisions/ux-pages/people-directory.html](decisions/ux-pages/people-directory.html)
- [employee-detail-inline-edit-with-reserved-tabs](decisions/ui/employee-detail-inline-edit-with-reserved-tabs.md)
  — hybrid of inline per-section edit (no modal, nothing hidden) with
  top-level tabs reserved only for genuinely separate future modules
  (Loan Ledger, Benefits); chosen over a summary+modal and a fully
  tabbed layout; mockup at
  [decisions/ux-pages/employee-detail.html](decisions/ux-pages/employee-detail.html)
- [add-employee-split-live-preview](decisions/ui/add-employee-split-live-preview.md)
  — form paired with a live directory-card preview, chosen over a
  single-page form and a multi-step wizard; shows the actual result
  before commit, matching "HR adds a hire once and it's correct
  everywhere"; closes out v1 People; mockup at
  [decisions/ux-pages/add-employee.html](decisions/ux-pages/add-employee.html)
- [company-reviews-roster-filterable-grid-list](decisions/ui/company-reviews-roster-filterable-grid-list.md)
  — HR-Admin company-wide review cycle list (Post-MVP, Performance
  Reviews); flat filterable roster with a card/list toggle and
  pagination, chosen over a department rollup and a cycle-first list;
  reviews stay manager-authored, HR views read-only; mockup at
  [decisions/ux-pages/company-reviews.html](decisions/ux-pages/company-reviews.html)
- [reports-landing-grid-drill-in](decisions/ui/reports-landing-grid-drill-in.md)
  — HR-Admin Reports (Post-MVP, basic-reporting), the fixed set of 7
  views; card-grid landing with a one-line description per report,
  chosen over a persistent report rail and a pill-tab switcher for its
  teaching value on names HR is still learning; each report's filters
  match what's actually filterable (as-of date, cutoff, or period, not
  one bar for all); mockup at
  [decisions/ux-pages/reports.html](decisions/ux-pages/reports.html)
- [employee-benefits-repeatable-plan-cards](decisions/ui/employee-benefits-repeatable-plan-cards.md)
  — the Benefits tab content on Employee Detail (Post-MVP, benefits,
  record-keeping only); one editable card per enrollment, chosen over
  a single flat section and a compact expandable list; the only option
  that doesn't assume exactly one benefit plan per employee; mockup at
  [decisions/ux-pages/employee-benefits.html](decisions/ux-pages/employee-benefits.html)
- [compliance-certifications-pinned-attention-full-list](decisions/ui/compliance-certifications-pinned-attention-full-list.md)
  — HR-Admin Compliance/Certifications (Post-MVP,
  compliance-certification-tracking, customer-dependent); a single
  list sorted by soonest-expiring, chosen over a plain flat list and
  an urgency-grouped sections option; adds a pinned "needs attention"
  summary strip above the unmodified sorted table, in service of the
  plan's own "god moments" north star; mockup at
  [decisions/ux-pages/compliance-certifications.html](decisions/ux-pages/compliance-certifications.html)
- [time-attendance-attendance-first-templates-drawer](decisions/ui/time-attendance-attendance-first-templates-drawer.md)
  — HR-Admin Time & Attendance (Post-MVP, time-attendance,
  customer-dependent); Attendance Records given the full page, chosen
  over a stacked-sections option and a segmented-switch option; Shift
  Templates tucked behind a "Manage shift templates" slide-over drawer
  since it's edited far less often than attendance is checked; mockup
  at [decisions/ux-pages/time-attendance.html](decisions/ux-pages/time-attendance.html)
- [payroll-run-detail-master-table-edit-drawer](decisions/ui/payroll-run-detail-master-table-edit-drawer.md)
  — HR-Admin Payroll Run Detail (v2, payroll-v2); line items per
  employee via a permanent master table, chosen over a flat
  expandable-row option and a roster+split-detail option; editing one
  employee's adjustments opens a right-side slide-over drawer (same
  mechanic as Time & Attendance's templates drawer), table stays
  visible and scrollable behind it; Finalize opens a blocked-state
  modal when employees are still missing OT, no approval step; mockup
  at [decisions/ux-pages/payroll-run-detail.html](decisions/ux-pages/payroll-run-detail.html)
- [payslip-detail-admin-breakdown-audit-rail](decisions/ui/payslip-detail-admin-breakdown-audit-rail.md)
  — HR-Admin Payslip Detail (v2, payroll-v2), one employee's
  already-finalized payslip; breakdown reused from My Payslips plus a
  persistent right-side rail (Record/Delivery/Correction history),
  chosen over a flat statement+action-bar option and a literal
  document-preview option; no inline editing — corrections go through
  a Void & Reissue modal since finalized line items are locked; mockup
  at [decisions/ux-pages/payslip-detail-admin.html](decisions/ux-pages/payslip-detail-admin.html)
- [rate-tables-landing-cards-edit-drawer](decisions/ui/rate-tables-landing-cards-edit-drawer.md)
  — HR-Admin Rate Tables (v2, payroll-v2), the SSS/PhilHealth/Pag-IBIG/BIR
  editable statutory tables referenced from Payroll Run Detail; a landing
  dashboard of agency cards (effective date, last-updated, a "not
  reviewed in over a year" caution badge) chosen over an agency-tabs
  inline-edit option and a stacked-accordion option; editing opens a
  right-side drawer reusing the Payroll Run Detail/Time & Attendance
  drawer mechanic, directly editable with no separate view/edit toggle
  since opening it already signals intent to edit; mockup at
  [decisions/ux-pages/rate-tables.html](decisions/ux-pages/rate-tables.html)
- [payroll-runs-pinned-open-run](decisions/ui/payroll-runs-pinned-open-run.md)
  — HR-Admin Payroll Runs landing page (v2, payroll-v2), the plan's own
  step 1 "HR opens a pay period"; a pinned dark hero card for the
  currently-open run (status, provisional gross, a missing-OT caution
  flag, "Continue payroll run") above the full paginated run history,
  chosen over a flat table with the open run as just the first row and
  a stat-strip-plus-year-grouped-list option; built ahead of the
  roadmap same as My Payslips; mockup at
  [decisions/ux-pages/payroll-runs.html](decisions/ux-pages/payroll-runs.html)
- [loan-ledger-flat-table-edit-drawer](decisions/ui/loan-ledger-flat-table-edit-drawer.md)
  — the Loan Ledger tab content on Employee Detail (v2, payroll-v2); a
  single master table (loan type, total, monthly amortization,
  remaining, progress, status) with per-row editing in a right-side
  drawer, chosen over repeatable progress cards (Benefits' own pattern)
  and a compact list with paid-off loans collapsed; the fourth reuse of
  the Payroll Run Detail/Time & Attendance/Rate Tables drawer mechanic;
  mockup at
  [decisions/ux-pages/employee-loan-ledger.html](decisions/ux-pages/employee-loan-ledger.html)
- [thirteenth-month-toggle-inline-payout-preview](decisions/ui/thirteenth-month-toggle-inline-payout-preview.md)
  — HR-Admin Payroll Settings (v2, payroll-v2), the new home for the
  `thirteenth_month_pay_enabled` company toggle; a settings card whose
  switch reveals an inline payout preview (employees covered, projected
  payout, Dec 24 deadline) when ON, chosen over a plain toggle row and a
  compliance-guarded toggle requiring a recorded exemption reason to
  disable — no confirmation step, the switch stays instant; first mockup
  of the Payroll Settings screen itself; mockup at
  [decisions/ux-pages/payroll-settings.html](decisions/ux-pages/payroll-settings.html)
- [job-openings-card-grid-with-list-toggle](decisions/ui/job-openings-card-grid-with-list-toggle.md)
  — HR-Admin Job Openings landing page (post-MVP, recruitment-ats,
  deliberately deferred to last); card grid (title/status/pipeline-stage
  counts/copy-link), chosen over a flat table and an open-section +
  collapsible-closed-archive split, with a card/list view toggle added on
  top reusing People Directory's exact mechanic, card selected by
  default; first mockup of the Recruitment module; mockup at
  [decisions/ux-pages/job-openings.html](decisions/ux-pages/job-openings.html)
- [job-opening-detail-kanban-stage-columns](decisions/ui/job-opening-detail-kanban-stage-columns.md)
  — HR-Admin Job Opening Detail + Candidate Pipeline (post-MVP,
  recruitment-ats), where "View pipeline" lands; five fixed-stage columns
  (New/Interviewing/Offer/Hired/Rejected) each holding compact candidate
  cards, stage changed via a per-card dropdown (never drag-and-drop, per
  the plan's own wording), chosen over a flat filterable table and a split
  roster + candidate detail panel; Offer cards get a "Mark Hired" button,
  Hired cards get a distinct "Employee record created" tag for the plan's
  payoff moment; mockup at
  [decisions/ux-pages/job-opening-detail.html](decisions/ux-pages/job-opening-detail.html)
- [job-application-form-split-panel](decisions/ui/job-application-form-split-panel.md)
  — the public, unauthenticated candidate Job Application Form
  (post-MVP, recruitment-ats) — the actual page an "application link"
  points to; reuses the Login page's exact brand-pane + form-pane split
  (job posting left, form right — name/email/phone/résumé/optional note,
  the plan's fixed field list), chosen over a single-page form and a
  multi-step wizard; no internal HRIS chrome, illustrative employer
  branding since this page is white-labeled to the SME in production;
  mockup at
  [decisions/ux-pages/job-application-form.html](decisions/ux-pages/job-application-form.html)
- [hired-handoff-review-and-edit-drawer](decisions/ui/hired-handoff-review-and-edit-drawer.md)
  — what "Mark Hired" actually opens on
  [[job-opening-detail-kanban-stage-columns|Job Opening Detail]]
  (post-MVP, recruitment-ats), left unscoped there; a right-side
  slide-over drawer (5th reuse of the Payroll Run Detail/Time &
  Attendance/Rate Tables/Loan Ledger drawer mechanic) with name/email
  locked in from the application and department/manager/start
  date/employment type editable before creating the employee record,
  chosen over a lightweight confirm modal and a redirect into the full
  Add Employee page; mockup at
  [decisions/ux-pages/hired-handoff.html](decisions/ux-pages/hired-handoff.html)

## Reference
- [ph-hr-payroll-compliance-glossary](reference/ph-hr-payroll-compliance-glossary.md)
  — SSS/PhilHealth/Pag-IBIG/BIR/13th-month/DOLE basics relevant to this
  project

## People

(none yet)
