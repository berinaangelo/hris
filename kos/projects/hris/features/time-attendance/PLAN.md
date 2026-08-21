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
3. Employee clocks in/out each day (or HR records it).
4. System compares actual time against the assigned shift and flags
   late/undertime.
5. HR sees a daily/period attendance list per employee.

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
- Daily clock-in/clock-out record per employee (simple digital punch or
  manual entry by HR)
- Late/undertime flag — actual vs. assigned shift, a comparison, not a
  pay computation
- Attendance list view per employee/period

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

## Related decisions

- [[statutory-deductions-as-editable-data-not-code]] — same
  data-over-engine principle applied to shift templates
