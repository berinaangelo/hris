# HRIS — Plan

Status: planning — v1 (MVP) scoped, v2 (payroll) scoped and deferred, five
  features scoped as post-MVP backlog, one feature scrapped with a fallback
  design on file
Market: Philippines (SMEs)
Tech stack: Ruby on Rails, Hotwire (Turbo + Stimulus), SCSS, Bulma, MySQL
  — see [[tech-stack-hotwire-over-coffeescript]] for why Hotwire replaced
  the originally-planned CoffeeScript
Last updated: 2026-08-21

## One-sentence description

An HRIS keeps one accurate record per employee and lets employees request
time off that their manager approves — no spreadsheets, no email chains.

## Primary flow (the thing this product is for) — v1

1. **Add** — HR adds an employee once: profile + manager (org position),
   an onboarding checklist, and any starting documents (contract, IDs).
2. **See** — employee logs in and their profile, manager, and team are
   already correct — nothing to fill in blindly.
3. **Request** — employee requests leave (dates + reason), seeing their
   real remaining balance on the same screen.
4. **Approve** — the employee's manager sees it in one inbox, with the
   balance shown inline, and approves/denies in one click.
5. **Resolve** — balance updates, both employee and manager are notified
   the same day.

No step requires the user to configure anything — org routing, balance
math, and notifications are invisible to the user.

## Necessary building blocks — v1

Each one exists because the primary flow breaks without it — not because
it'd be nice to have.

| # | Block | Why it's required | Flow step |
|---|---|---|---|
| 1 | Employee profile (fixed schema, not a custom-field builder) | Single source of truth — the core "H" in HRIS | Add |
| 2 | Org structure (`manager_id`) | Routes approvals; drives directory/org-chart view | Add, Approve |
| 3 | Role-based access (employee / manager / admin — three roles, not a permissions matrix) | Approval flow requires distinguishing who can approve/see what | all |
| 4 | Time-off request + live balance | The flagship self-service flow | Request |
| 5 | Single-level manager approval | Closes the loop without configurable-chain complexity — see [[approval-chains-scrapped-fallback-design]] | Approve |
| 6 | Notifications (email, on request/decision) | The async flow breaks without someone being told to act | Request, Approve |
| 7 | Onboarding checklist (fixed list attached to the profile, not a workflow builder) | Core feature, not cut — every non-cut core feature belongs in v1, not deferred | Add |
| 8 | Document storage (plain upload/download, no e-signature) | Core feature, not cut — same reasoning as #7 | Add |

## God moments (design north star)

The pattern every screen is held to: **the right fact is already visible,
with zero setup or asking around.** If a screen requires the user to
already know something the system could have told them, it's not done.

- New employee logs in and their profile/manager/team are already correct
- Employee sees their real balance before submitting a leave request
- Employee gets notified same-day when a request is decided — never has
  to chase HR
- Manager approves from one inbox with balance shown inline — no
  cross-checking a spreadsheet
- HR adds a hire once and it's correct everywhere — never edited twice
- "Who's out this week" is answerable by looking, not asking

## Roadmap tiers

| Tier | Item | Status |
|---|---|---|
| v1 (MVP) | Core flow above | scoping done |
| v2 (committed, next after MVP) | [Payroll](features/payroll-v2/PLAN.md) | scoped |
| Post-MVP backlog (build only when a real customer needs it) | [Performance reviews/goals](features/performance-reviews-goals/PLAN.md) | scoped |
| Post-MVP backlog | [Basic reporting](features/basic-reporting/PLAN.md) | scoped |
| Post-MVP backlog | [Compliance/certification tracking](features/compliance-certification-tracking/PLAN.md) | scoped, customer-dependent |
| Post-MVP backlog | [Recruitment/ATS](features/recruitment-ats/PLAN.md) | scoped |
| Post-MVP backlog | [Benefits](features/benefits/PLAN.md) | scoped, record-keeping only |
| Post-MVP backlog | [Time & Attendance](features/time-attendance/PLAN.md) | scoped, customer-dependent |
| Scrapped | Multi-step/configurable approval chains | see [[approval-chains-scrapped-fallback-design]] |

## Explicitly out of scope for v1

Everything in the roadmap table above except the v1 row. None of it
breaks the primary flow described above — each was evaluated against the
"why does this exist" gate individually (see each feature's own PLAN.md
for its in/out breakdown).

Also cut outright, not just deferred:
- Payroll processing built in-house without payroll being its own
  version — moved to v2, never bundled into v1
- Recruitment/ATS as a full pipeline (job boards, resume parsing,
  interview scheduling, offer letters) — see
  [[ats-checker-reuse-parked-for-recruitment]] for the one adjacent asset
  that is worth keeping in mind
- Any admin-facing settings/config screen for something that can instead
  be a sensible default — recurring principle across every feature, see
  [[statutory-deductions-as-editable-data-not-code]] and
  [[vendor-fragmented-features-record-keeping-only]]

## Five-gates check — v1

- **One-sentence** ✅ — see description above, no "and" stacking
- **Grandma test** ✅ — add → see → request → approve → resolve; no
  config or manual needed at any step
- **Demo test** ✅ — walkable live start to finish once the 6 blocks
  exist; no "and then in a future version..."
- **Why-does-this-exist** ✅ — every block traces to a flow step, not to
  "might need it"
- **One-narrative** ✅ — a single story (employee record → leave request →
  approval), not a checklist of unrelated features
