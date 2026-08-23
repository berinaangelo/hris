---
title: roles-access-reference-plus-assignment-drawer
tags: [hris, design, company-tab, authorization]
date: 2026-08-23
---

Roles & Access (HR-Admin, Company tab) — a screen scoped down from a full
"role management" UI to only what's actually in scope: the three roles
(employee / manager / admin) are fixed, not user-configurable, per
[[../rails-pundit-for-authorization|the Pundit decision]] and the plan's
own "three roles, not a permissions matrix"
(kos/projects/hris/PLAN.md). Built directly, no three-option comparison —
the user asked for a single best answer given how the rest of the UX
ecosystem is already built. Mockup at
[decisions/ux-pages/roles-access.html](../ux-pages/roles-access.html).

**Two sections, two different edit rules:**
- **Reference (read-only):** three role cards plus a capability
  comparison table — a checkbox per capability per role, all `disabled`.
  This is the "checkbox for permissions" the user asked for, but it
  describes what a role can already do; it isn't an editable matrix.
  Capabilities map straight onto
  [[navigation-me-team-company|the Me/Team/Company nav structure]] — Me
  (all roles), Team (manager and up), Company (admin only) — plus the
  Pundit `approve?` example's own scoping (a manager approves only their
  own direct reports, not company-wide).
- **Assignment (the only editable part):** a roster table (reused
  People Directory's exact 13-person data set and table styling) with
  an Access Level chip per row and a "Change" action. Change opens a
  right-side drawer (10th reuse of the drawer mechanic established in
  Payroll Run Detail / Time & Attendance / Rate Tables / Loan Ledger /
  Hired Handoff / Job Opening Form / Offboarding) with three
  radio-selectable role cards, each repeating that role's one-line
  description so the admin sees what they're granting before saving.

**Sole-Admin safeguard:** Andrea Cruz is the only Admin in the data set
(the same four department-head structure established in
[[org-chart-classic-top-down-tree]] — Ramon/Ferdinand/Miguel as
Managers, Andrea as the lone Admin/HR head). Her drawer disables the
Employee and Manager options with a caution note — HRIS needs at least
one Admin, so removing the last one is blocked rather than silently
allowed, the same "block the risky action, don't just warn" pattern as
Payroll Run Detail's missing-OT Finalize guard. Every other employee's
drawer (demonstrated on Mikaela Santos) has all three options open.
Offboarding/Offboarded rows (Jonas Rivera, Kristine Aquino) get a
disabled Change action instead — access on a departing or already-gone
employee isn't reassigned, it's just not relevant anymore.

**Why chips instead of the four-category status badges:** access level
isn't a status (nothing here is pending/succeeded/failed) so it gets
its own three-tone chip scale off the base Ink & Amber palette rather
than overloading
[[badge-system-four-categories|the badge system's]] semantic categories.

**Not in scope, deliberately:** creating/editing/deleting roles, a
configurable permission matrix, and per-employee custom permission
overrides. If a real customer ever needs finer-grained access than
these three roles, that's a new plan-level decision, not something this
screen grows into.
