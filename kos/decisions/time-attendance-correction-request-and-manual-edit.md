---
title: time-attendance-correction-request-and-manual-edit
tags: [hris, scope, time-attendance, payroll]
date: 2026-08-23
---

Extended [[../projects/hris/features/time-attendance/PLAN.md|time-attendance]]'s
scope with a correction/manual-edit flow — user-specified directly, not a
three-option comparison:

- An employee never edits their own clock-in/clock-out. A wrong or missed
  punch gets flagged as a **correction request** to their supervisor or
  an admin instead.
- Both **supervisor** (manager) and **admin** can manually edit an
  employee's clock-in/clock-out — same capability, not admin-only.
- That capability is gated by one company-level permission,
  `attendance_manual_edit_enabled`, **default on**. Turning it off
  removes the edit action for both roles — this is a toggle, not a new
  role or a cell in a permissions matrix, consistent with
  [[rails-pundit-for-authorization]]'s fixed employee/manager/admin roles
  and [[ui/roles-access-reference-plus-assignment-drawer|Roles &
  Access]]'s "not a permissions matrix" scoping.
- An **optional attendance approver** step, `attendance_approvers_enabled`,
  **default off** (my own default — company toggles this on if they want
  sign-off oversight on edits; not specified by the user, flagging it as
  an assumption). On or off, payroll always uses the attendance record as
  it currently stands — approval status is never a gate on payroll
  inclusion, it's oversight only.
- Stays a **single optional approver**, not a chain — matches
  [[approval-chains-scrapped-fallback-design]]'s already-scrapped
  multi-step/conditional approval chains, applied here rather than
  re-opening that decision.

**Why this shape:** mirrors the real distinction the user drew — self-edit
is never allowed (data integrity: a punch record an employee could
silently rewrite isn't trustworthy), correction is a request-then-fix
flow with two people capable of fixing it, and the permission/approver
layer is administrative control, not a payroll gate. Keeping the
manual-edit permission a single company-wide toggle rather than a
per-supervisor or per-admin setting keeps it out of Roles & Access's
fixed three-role scope.

**Mockup built 2026-08-23**, added to the existing chosen layout only
(Option 3, "Attendance-first + drawer") — Options 1–2 stay frozen as the
original three-way comparison, not touched:
- A demo-only **Viewing as: HR Admin / Manager** role switch previews the
  supervisor-access resolution from
  [[ui/time-attendance-attendance-first-templates-drawer]]'s own open
  question: reuse this one page for both roles rather than build a
  separate Team-tab page, row-scoped to reports only. Manager view is
  Ramon Dela Cruz, scoped to his 5 direct reports (per
  [[ui/org-chart-classic-top-down-tree]]'s own org data); nav swaps
  Company↔Team, "Manage shift templates"/"Record attendance"/the
  Attendance Settings card go admin-only (company-level config).
- A **Correction requests** card (caution-tinted, admin sees all pending,
  manager sees only their own team's) with a disabled "Review" action per
  request.
- A disabled **Edit** icon-button in a new Actions column on every
  attendance row (both roles) — except the viewing manager's own row,
  which shows a plain em-dash: self-edit stays disallowed even for a
  manager reviewing their own attendance.
- An **Attendance Settings** card (admin-only) with the two toggles from
  this decision, shown locked/disabled at their defaults — Manual edit
  permission "On", Attendance approvers "Off" — same lock-icon/disabled
  visual language as
  [[ui/payroll-settings-parked-overtime-deduction-defaults]].

Nothing here is wired — no correction-request form, no edit drawer body,
no toggle interaction. Still open: what the correction-request submission
form looks like, what opens when "Review"/"Edit" is clicked, and the
approver sign-off screen if that toggle is ever turned on.

HTML mockup: [[ux-pages/time-attendance.html]]
