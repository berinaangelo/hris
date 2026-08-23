# Time & Attendance — Plan

Status: post-MVP backlog — scoped, customer-dependent (build only if a
  target customer has a shift-based/hourly workforce)
Last updated: 2026-08-21

## One-sentence description

Each employee is assigned to a company-defined shift template, clocks
in/out against it, and the system flags late/undertime — companies
define their own shift templates rather than the system assuming one
fixed schedule.

## Core flow

1. HR defines shift templates for the company — a name plus start/end
   time (e.g. "Dayshift" 9:00–18:00, "Midshift" 16:00–22:00 — the
   common PH pattern).
2. HR assigns each employee to a shift template.
3. Employee clocks in/out each day.
4. System compares actual time against the assigned shift and flags
   late/undertime.
5. HR/supervisor sees a daily/period attendance list per employee.
6. If a punch is wrong or missed, the employee can't edit it themselves —
   they request a correction from their supervisor or an admin.
7. Supervisor or admin manually edits the employee's clock-in/clock-out,
   gated by a company-level permission (`attendance_manual_edit_enabled`,
   default **on**) — turning it off removes the edit action for both
   roles.
8. Optionally, a company can require an approver to sign off on
   attendance edits/corrections (`attendance_approvers_enabled`, default
   **off**) — purely an oversight layer. On or off, the current
   attendance record is what payroll uses; approval status never gates
   payroll inclusion.

## Why "configurable" means a template list, not a scheduling engine

Same data-not-code principle as
[[statutory-deductions-as-editable-data-not-code]]: shift templates are
a short company-maintained list (name, start_time, end_time), not a
rules engine. HR adds/edits templates directly — no rotating-schedule
builder, no per-day overrides, no shift-swap workflow. That's what keeps
"configurable" from becoming its own scheduling product.

## In scope

- `shift_templates` (company-level): `name`, `start_time`, `end_time` —
  editable list
- Employee assigned to one `shift_template`
- Daily clock-in/clock-out record per employee — a digital self-punch;
  employees never edit their own record directly
- Late/undertime flag — actual vs. assigned shift, a comparison, not a
  pay computation
- Attendance list view per employee/period
- Correction requests — an employee flags a wrong/missed punch to their
  supervisor or an admin instead of editing it themselves
- Manual edit — supervisor and admin can both edit an employee's
  clock-in/clock-out, gated by one company-level permission,
  `attendance_manual_edit_enabled` (default on)
- Optional attendance approver — a company-level toggle,
  `attendance_approvers_enabled` (default off); when on, edits/
  corrections get a sign-off step, but this never blocks payroll from
  using the record as it currently stands

## Out of scope

- Rotating/dynamic schedules, per-day overrides, shift swapping/bidding
- Auto-feed into payroll OT/deductions — stays manual entry in payroll,
  per [[../payroll-v2/PLAN.md|payroll v2's]] existing out-of-scope
  decision; revisit only if that becomes the actual bottleneck
- Night differential / holiday pay / rest day pay computation (PH labor
  law premiums) — real, but a pay-computation feature, not an
  attendance-tracking one; a later addition if ever needed
- Biometric/hardware time clock integration
- Geolocation/IP-based punch validation
- Break time tracking
- Employees editing their own clock-in/clock-out directly — always goes
  through a correction request instead
- Multi-step/conditional approver chains for attendance — per
  [[../../../decisions/approval-chains-scrapped-fallback-design]], stays
  a single optional approver, not a chain, same as the leave-request
  fallback design

## Related decisions

- [[statutory-deductions-as-editable-data-not-code]] — same
  data-over-engine principle applied to shift templates
- [[../../../decisions/approval-chains-scrapped-fallback-design]] —
  single optional approver only, no chain, for the same reasons
- [[../../../decisions/rails-pundit-for-authorization]] — manual-edit
  permission is a company-level toggle, not a new role or a permissions
  matrix cell (roles stay employee/manager/admin, fixed)
