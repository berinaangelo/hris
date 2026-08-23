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

**Synced 2026-08-23** — the real backend for this scope has since shipped
(in order: clock-in/clock-out → correction requests → manual edit →
settings toggle UI/dashboard badge → approver sign-off), resolving the
"still open" items above:
- **Attendance Settings card** now reads as live, not parked: the lock
  icon/"Setting, not wired" tooltip is gone, and copy was tightened to the
  real `Company#attendance_manual_edit_enabled`/`attendance_approvers_enabled`
  labels and helper text verbatim, plus a "Save settings" action. Unlike
  the genuinely-parked [[ui/payroll-settings-parked-overtime-deduction-defaults]]
  precedent this card originally borrowed its visual language from, this
  setting is real, so that borrowed language no longer applies here.
  **Demo-data note:** "Attendance approvers" is shown **On** in this
  mockup, though the real column default is Off — flipped on purely so the
  new Approval column below has pending/approved/rejected rows to
  demonstrate; not a change to the shipped default.
- **Edit** icon-button is enabled and opens a right-side edit drawer (12th
  reuse of the drawer mechanic — see
  [[ui/loan-ledger-flat-table-edit-drawer]] for the precedent) with clock-in,
  clock-out, and an optional reason field — matches the real
  `Attendance::UpdateRecord` interactor's minimal footprint. One shared,
  illustrative drawer (subject: Isabel Torres) since this is static HTML,
  not a real per-row form. Self-edit block on Ramon Dela Cruz's own row is
  unchanged.
- **Review** (on a correction-request card) is enabled and opens its own
  drawer (13th reuse) — reason, current-vs-requested clock in/out, and
  Approve/Reject actions. Kept as a distinct entry point from Edit per the
  real distinction between an employee-submitted correction request and an
  admin/manager's direct edit — two illustrative drawers built (Diego
  Reyes, shared across the admin/manager cards he appears in; Isabel
  Torres, admin-only) rather than one, so each Review button's content
  matches the row that triggered it.
- **New "Approval" status column** added to the attendance table, between
  Status and Actions — reuses [[ui/badge-system-four-categories]]'s
  existing caution/positive/negative badge classes for
  `edit_approval_status` pending/approved/rejected, "—" for the common
  `not_required` case (no manual edit has touched that record). Diego
  Reyes shows "Pending" (ties to his open correction request), Grace Lim
  "Approved", Bea Fernandez "Rejected" — demonstrates all three states in
  one screenshot.

Still open: the separate admin-only **Attendance Sign-offs inbox** page
(`/team/attendance_edit_approvals` in the real app, with its own nav badge)
is not mocked in this pass — this screen doesn't reference or link to it.

HTML mockup: [[ux-pages/time-attendance.html]]
