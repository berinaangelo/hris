---
title: core-v1-schema
tags: [hris, schema, database, v1]
date: 2026-08-23
---

DB schema for the v1 (MVP) core flow — [[../../projects/hris/PLAN.md|add
→ see → request → approve → resolve]] — plus the ad hoc account/auth
screens ([[../ui/login-page-split-panel]],
[[../ui/password-recovery-flow-split-panel]],
[[../ui/account-settings-summary-plus-modal]]). Companion doc:
[[time-attendance-schema]]. MySQL 8, translated 1:1 into the migrations
under `db/migrate/` and models under `app/models/`.

**Assumption flagged, not decided elsewhere:** auth is plain Rails
`has_secure_password` (bcrypt) on `employees` directly — one table, not
a separate `users` + `employees` split — since every auth screen
(login, forgot/reset password, account settings) is already a fully
custom UI, not Devise's default views/controllers, and the v1 PLAN
treats "employee" as the one login-capable identity (no separate
customer/vendor login concept exists in this product).

## companies

One row per customer (multi-tenant). Also carries the two
time-attendance company-level toggles from
[[../time-attendance-correction-request-and-manual-edit]] — kept on
`companies` rather than a separate `settings` table since v1 has only
two boolean toggles total; revisit as a real key-value settings table
only once a third company-level toggle shows up.

| Column | Type | Notes |
|---|---|---|
| name | string, not null | |
| timezone | string, not null, default `"Asia/Manila"` | |
| attendance_manual_edit_enabled | boolean, not null, default `true` | see [[../time-attendance-correction-request-and-manual-edit]] |
| attendance_approvers_enabled | boolean, not null, default `false` | see [[../time-attendance-correction-request-and-manual-edit]] |

No indexes beyond the PK — small table, always loaded by PK
(`current_employee.company`).

## employees

The single authenticatable + HR-profile record. Role and status are
plain Rails `enum` (not the `Statusable` metaprogramming pattern from
[[../rails-metaprogramming-for-repetitive-methods]] — enum already
gives `role.manager?`/`status.offboarding!` for free, which is exactly
the case that decision says NOT to hand-roll).

| Column | Type | Notes |
|---|---|---|
| company_id | bigint, FK, not null | |
| manager_id | bigint, FK → employees, nullable | self-referential; null for the top of the org (e.g. the sole Admin/HR head, per [[../ui/roles-access-reference-plus-assignment-drawer]]) |
| shift_template_id | bigint, FK → shift_templates, nullable | see [[time-attendance-schema]]; nullable — not every company/employee uses shift attendance |
| employee_number | string, not null | e.g. `EMP-0089`, shown throughout the UI |
| role | integer (enum: employee, manager, admin), not null, default `employee` | fixed 3 roles, not a permissions matrix, per [[../rails-pundit-for-authorization]] |
| status | integer (enum: active, offboarding, offboarded), not null, default `active` | per [[../ui/badge-system-four-categories]] / [[../ui/offboarding-flow-schedule-clearance-tracker]] |
| first_name, last_name | string, not null | |
| work_email | string, not null | login identity |
| personal_email | string, nullable | account-setup invite target, per [[../ui/add-employee-split-live-preview]] |
| password_digest | string, not null | `has_secure_password` |
| password_changed_at | datetime, nullable | shown on [[../ui/account-settings-summary-plus-modal]] |
| last_login_at | datetime, nullable | shown on [[../ui/account-settings-summary-plus-modal]] |
| mobile_number | string, nullable | employee-edited, per [[../ui/my-profile-summary-plus-modal]] |
| home_address | string, nullable | employee-edited |
| birthdate | date, nullable | employee-edited |
| emergency_contact_name | string, nullable | employee-edited |
| emergency_contact_phone | string, nullable | employee-edited |
| job_title | string, not null | HR-managed |
| department | string, not null | HR-managed; plain string, not a `departments` table — no admin screen anywhere decides a company-managed department list (unlike shift templates/leave types), so this stays a fixed field, not editable data, until a real screen needs it |
| employment_type | integer (enum: full_time, part_time, contract), not null, default `full_time` | |
| start_date | date, not null | |
| last_working_day | date, nullable | offboarding, per [[../ui/offboarding-flow-schedule-clearance-tracker]] |
| offboarding_reason | string, nullable | |
| rehire_eligible | boolean, nullable | |
| offboarding_notes | text, nullable | |
| leave_request_updates_notifications | boolean, not null, default `true` | account settings toggle |
| new_payslip_notifications | boolean, not null, default `true` | account settings toggle |
| review_cycle_notifications | boolean, not null, default `true` | account settings toggle |
| company_announcement_notifications | boolean, not null, default `true` | account settings toggle |
| lock_version | integer, not null, default `0` | optimistic locking on profile edits, per [[../rails-db-transactions-locking-idempotency]] |

**Indexes**
- `company_id`
- `manager_id`
- `shift_template_id`
- unique `work_email`
- unique `[company_id, employee_number]`
- `[company_id, status]` — People Directory's active/offboarding/
  offboarded filter, per [[../ui/people-directory-card-grid-with-list-toggle]]
- `[company_id, role]` — Roles & Access roster, Team-tab manager checks

## checklist_items

One table for both onboarding and offboarding checklists — they're the
same shape (a fixed, code-defined list of items per employee, each
markable done), per
[[../ui/offboarding-flow-schedule-clearance-tracker]]'s own framing of
offboarding as "the Onboarding checklist... run in reverse." The fixed
item lists themselves are NOT a DB table — they're a `checklist_type`
Rails enum + a small `item_key` allowlist per membership.
(reference tests via
[[../rails-testing-minitest-factorybot-faker]]).

```ruby
# app/models/checklist_item.rb (excerpt) — the fixed lists live in code,
# not in the DB, per the PLAN's "fixed list, not a workflow builder":
ONBOARDING_ITEM_KEYS = %w[
  employment_contract_signed
  government_ids_submitted
  company_equipment_issued
].freeze

OFFBOARDING_ITEM_KEYS = %w[
  equipment_returned
  system_access_revoked
  final_pay_clearance_computed
  exit_interview_completed
].freeze
```

| Column | Type | Notes |
|---|---|---|
| employee_id | bigint, FK, not null | |
| checklist_type | integer (enum: onboarding, offboarding), not null | |
| item_key | string, not null | one of the `*_ITEM_KEYS` above |
| position | integer, not null | display order |
| completed_at | datetime, nullable | null = pending |

Rows are bulk-inserted (`insert_all`, per
[[../rails-orm-performance-n-plus-one-and-indexes]]) when an employee is
created (`Employees::AttachOnboardingChecklist`, per
[[../rails-thin-controllers-organizer-interactor-pattern]]) or offboarded
(`Employees::AttachOffboardingChecklist`) — never one-by-one `.create`
calls.

**Indexes**
- unique `[employee_id, checklist_type, item_key]`
- `[employee_id, checklist_type]` — the two checklist cards' own queries

## documents

Metadata wrapper around an Active Storage attachment (`has_one_attached
:file`) — "plain upload/download, no e-signature" per the v1 PLAN.
Active Storage's own tables (`active_storage_blobs`,
`active_storage_attachments`, `active_storage_variant_records`) come
from the standard `bin/rails active_storage:install` generator content,
included as `db/migrate/20260823120000_create_active_storage_tables
.active_storage.rb` so `db:migrate` doesn't need a separate manual
step.

| Column | Type | Notes |
|---|---|---|
| employee_id | bigint, FK, not null | whose record this document lives under |
| uploaded_by_id | bigint, FK → employees, nullable | who uploaded it (self or HR) |
| title | string, not null | |
| category | integer (enum: contract, government_id, certificate, other), not null, default `other` | |

**Indexes**
- `employee_id`
- `uploaded_by_id`

## leave_types

A short company-editable list (Vacation, Sick, Emergency, Others is the
placeholder seed content, per
[[../ui/time-off-list-plus-modal]]) — kept as editable data rather than
a hardcoded enum, mirroring the same data-not-code reasoning already
used for [[../time-attendance/PLAN.md|shift templates]] and
[[../statutory-deductions-as-editable-data-not-code]]. Not explicitly
decided as company-scoped anywhere — flagged as my own default, since
every other short editable list in this app is per-company.

| Column | Type | Notes |
|---|---|---|
| company_id | bigint, FK, not null | |
| name | string, not null | |

**Indexes**
- `company_id`
- unique `[company_id, name]`

## leave_balances — a summary/rollup table, on purpose

Unlike attendance (see [[time-attendance-schema]]), this one earns its
keep as a real, always-materialized rollup rather than a live query:
the Home dashboard's balance-led hero
([[../ui/home-dashboard-balance-led-hero]]) and the Time Off page's
top-of-page balance card ([[../ui/time-off-list-plus-modal]]) both need
an O(1) "days remaining" read on nearly every page load — re-summing
every historical `leave_requests` row per view is the exact kind of
query [[../rails-orm-performance-n-plus-one-and-indexes]] warns against.

```ruby
# Rollup mechanics (documented, not yet built — no accrual/entitlement
# policy is decided; home-dashboard-balance-led-hero.md and
# time-off-list-plus-modal.md both flag the 12.5/15 figures as
# placeholder content):
#
# entitled_days is set once per employee/leave_type/year — either a
# flat company default (seeded at year start / on hire) or a future
# accrual job; TBD when that policy is actually decided.
#
# used_days is NOT recomputed by a callback on leave_requests (per
# rails-callback-objects-for-cache-busting.md: business-flow side
# effects stay explicit Interactor steps, not AR callbacks). Instead:
#   - Leave::ApproveRequest interactor: used_days += request.days_requested
#   - Leave::RejectRequest interactor: no balance change (never counted)
#   - Leave::CancelApprovedRequest interactor: used_days -= request.days_requested
# Each runs inside `leave_balance.with_lock` (pessimistic, per
# rails-db-transactions-locking-idempotency.md) OR relies on the
# lock_version optimistic-locking column below — optimistic is enough
# here since concurrent edits to one person's own balance are rare,
# same reasoning that doc gives for profile edits.
#
# remaining_days is never stored — always (entitled_days - used_days),
# computed at read time, to avoid a third number drifting out of sync.
```

| Column | Type | Notes |
|---|---|---|
| employee_id | bigint, FK, not null | |
| leave_type_id | bigint, FK, not null | |
| year | integer, not null | calendar year the entitlement applies to |
| entitled_days | decimal(5,2), not null, default `0` | |
| used_days | decimal(5,2), not null, default `0` | |
| lock_version | integer, not null, default `0` | optimistic locking, per [[../rails-db-transactions-locking-idempotency]] |

**Indexes**
- unique `[employee_id, leave_type_id, year]` — also the row every
  balance read/write keys off of

## leave_requests

| Column | Type | Notes |
|---|---|---|
| employee_id | bigint, FK, not null | |
| leave_type_id | bigint, FK, not null | |
| approver_id | bigint, FK → employees, nullable | resolved from `employee.manager_id` at submission time, per single-level-only approval, [[../approval-chains-scrapped-fallback-design]] |
| status | integer (enum: pending, approved, rejected), not null, default `pending` | |
| start_date | date, not null | |
| end_date | date, not null | |
| days_requested | decimal(5,2), not null | |
| reason | text, nullable | "optional reason field" per [[../ui/time-off-list-plus-modal]] |
| decision_note | text, nullable | reject-with-note is still an open question per that same doc; column added now since it's cheap, left nullable/unused until decided |
| decided_at | datetime, nullable | |

Overlap validation (a new request can't overlap an existing
pending/approved one for the same employee) uses the Arel pattern from
[[../rails-arel-for-complex-queries]] — a plain `.where` hash can't
express the date-range OR/AND combination cleanly:

```ruby
class LeaveRequest < ApplicationRecord
  def self.overlapping(employee_id, start_date, end_date)
    t = arel_table
    where(employee_id: employee_id)
      .where.not(status: :rejected)
      .where(t[:start_date].lteq(end_date).and(t[:end_date].gteq(start_date)))
  end
end
```

**Indexes**
- `employee_id`
- `[approver_id, status]` — the Team Approvals inbox's exact query
  (a manager's pending requests), per
  [[../ui/team-approvals-inbox-inline-actions]]
- `[employee_id, start_date, end_date]` — overlap-check scan
- `status`

## Related decisions

- [[../../projects/hris/PLAN.md]] — v1 core flow and building blocks
- [[../rails-pundit-for-authorization]]
- [[../rails-db-transactions-locking-idempotency]]
- [[../rails-arel-for-complex-queries]]
- [[../rails-metaprogramming-for-repetitive-methods]]
- [[../rails-orm-performance-n-plus-one-and-indexes]]
- [[../rails-callback-objects-for-cache-busting]]
- [[time-attendance-schema]]
