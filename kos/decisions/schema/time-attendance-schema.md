---
title: time-attendance-schema
tags: [hris, schema, database, time-attendance]
date: 2026-08-23
---

DB schema for [[../../projects/hris/features/time-attendance/PLAN.md|Time
& Attendance]] (post-MVP backlog, customer-dependent — schema defined
now so it isn't orphaned relative to [[core-v1-schema]], which
`employees.shift_template_id` and every FK below depend on). See also
[[../time-attendance-correction-request-and-manual-edit]] for the
correction/manual-edit/approver behavior this schema encodes.

## shift_templates

Company-editable list, per the "data-not-code" reasoning already used
for [[../statutory-deductions-as-editable-data-not-code]] — HR adds/
edits rows directly, no scheduling-engine builder.

| Column | Type | Notes |
|---|---|---|
| company_id | bigint, FK, not null | |
| name | string, not null | e.g. "Dayshift", "Midshift", "Graveyard" |
| start_time | time, not null | |
| end_time | time, not null | |

**Indexes**
- `company_id`

## attendance_records

One row per employee per day. `shift_template_id` is copied from the
employee's assignment **at punch time**, not read live off `employees` —
an employee's shift assignment can change later, but a historical
day's late/undertime flag must keep comparing against the shift that
was actually in effect that day.

| Column | Type | Notes |
|---|---|---|
| employee_id | bigint, FK, not null | |
| shift_template_id | bigint, FK → shift_templates, not null | snapshot at punch time, see above |
| date | date, not null | |
| clock_in_at | datetime, nullable | null = no punch yet (absent, until end of day) |
| clock_out_at | datetime, nullable | null = still clocked in / missed punch |
| status | integer (enum: on_time, late, undertime, absent), nullable | computed at clock-out by an interactor comparing against `shift_template`, not stored redundantly elsewhere; null until clock-out resolves it |
| manually_edited | boolean, not null, default `false` | |
| edited_by_id | bigint, FK → employees, nullable | supervisor or admin, per [[../time-attendance-correction-request-and-manual-edit]]; gated by `companies.attendance_manual_edit_enabled` at the interactor/policy level, not by a DB constraint |
| edited_at | datetime, nullable | |
| edit_approval_status | integer (enum: not_required, pending, approved), not null, default `not_required` | only moves off `not_required` when `companies.attendance_approvers_enabled` is on; per that same decision, this NEVER gates payroll — it's an oversight flag read by nothing else |
| edit_approved_by_id | bigint, FK → employees, nullable | |
| edit_approved_at | datetime, nullable | |

**Indexes**
- unique `[employee_id, date]` — one record per employee per day; also
  the exact key every attendance-list/period query filters on
- `shift_template_id`
- `[employee_id, status]`
- `date` — company-wide daily views (e.g. "who hasn't clocked in today")

## attendance_correction_requests

Employee-initiated: "I never edit my own punch, I flag it instead." Kept
as its own table rather than folded into `attendance_records` because a
**missed** punch has no existing attendance row to attach to yet —
`attendance_record_id` is nullable for exactly that case, with `date`
carrying the day being corrected either way.

| Column | Type | Notes |
|---|---|---|
| employee_id | bigint, FK, not null | who's requesting the correction |
| attendance_record_id | bigint, FK → attendance_records, nullable | null when the punch was missed entirely (no row exists yet) |
| date | date, not null | the day being corrected |
| requested_clock_in_at | datetime, nullable | |
| requested_clock_out_at | datetime, nullable | |
| reason | text, not null | |
| status | integer (enum: pending, approved, rejected), not null, default `pending` | |
| reviewed_by_id | bigint, FK → employees, nullable | supervisor or admin — resolving a correction request already IS the approver step; no separate approval flag needed alongside it |
| reviewed_at | datetime, nullable | |

**Indexes**
- `employee_id`
- `attendance_record_id`
- `[status, employee_id]` — admin sees all pending; manager sees only
  their own team's (joined through `employees.manager_id`), per
  [[../time-attendance-correction-request-and-manual-edit]]
- `reviewed_by_id`

## Rollup mechanics — NOT built now, documented so it isn't forgotten

Attendance stays raw `attendance_records` rows for v1 of this feature —
the period list view ([[../ui/time-attendance-attendance-first-templates-drawer|
the Attendance-first layout]]) is a straightforward Pagy-paginated,
indexed query (`[employee_id, date]` already covers it), same reasoning
[[../ui/notifications-nav-badge-counts]] used to skip a stored table for
something a live query already answers cheaply. A summary table is
commented out below rather than built, per the instruction not to
build one unless a real report needs it yet — none does.

```ruby
# db/migrate/XXXXXXXXXXXXXX_create_attendance_period_summaries.rb
#
# Not created yet — parking the shape here so it isn't reinvented from
# scratch if/when it's actually needed. Two triggers that would justify
# building this for real:
#   1. Payroll OT/hours auto-feed ever gets built (currently explicit
#      out-of-scope per time-attendance/PLAN.md — "stays manual entry
#      in payroll" per payroll-v2's own out-of-scope decision).
#   2. The raw per-day query above stops being fast enough at real
#      company-year scale (unlikely pre-launch; MySQL handles a few
#      thousand `attendance_records` rows per company per year fine on
#      the [employee_id, date] index alone).
#
# class CreateAttendancePeriodSummaries < ActiveRecord::Migration[8.1]
#   def change
#     create_table :attendance_period_summaries do |t|
#       t.references :employee, null: false, foreign_key: true
#       t.date :period_start, null: false
#       t.date :period_end, null: false
#       t.decimal :hours_worked, precision: 6, scale: 2, null: false, default: 0
#       t.integer :late_count, null: false, default: 0
#       t.integer :undertime_count, null: false, default: 0
#       t.integer :absent_count, null: false, default: 0
#       t.timestamps
#     end
#     add_index :attendance_period_summaries, [:employee_id, :period_start], unique: true
#   end
# end
#
# Rollup mechanics if/when built: a nightly ActiveJob
# (Attendance::RollUpPeriodSummary, per
# rails-activejob-solid-queue-for-background-work.md) scans the
# previous day's finalized attendance_records (clock_out_at present,
# not still editable) and upserts (insert_all/upsert_all, per
# rails-orm-performance-n-plus-one-and-indexes.md — never looped saves)
# one row per employee per pay period, incrementing hours_worked/
# late_count/undertime_count/absent_count. Re-run idempotently for a
# period if a manual edit lands after the fact (edited_at > last
# rollup run for that period) rather than trying to patch the summary
# row incrementally in place.
```

## Related decisions

- [[../../projects/hris/features/time-attendance/PLAN.md]]
- [[../time-attendance-correction-request-and-manual-edit]]
- [[core-v1-schema]] — `employees.shift_template_id`,
  `companies.attendance_manual_edit_enabled`/`attendance_approvers_enabled`
- [[../rails-activejob-solid-queue-for-background-work]]
- [[../rails-orm-performance-n-plus-one-and-indexes]]
