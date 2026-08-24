---
title: attendance-corrections-list-plus-modal
tags: [hris, design, me-tab, time-attendance]
date: 2026-08-24
---

Attendance Corrections (Me tab, everyone) — the employee's own
self-service page for filing and tracking attendance-correction
requests, under Me → Attendance
([[navigation-me-team-company]], `attendance_correction_requests_path`,
already reserved in `navigation_presenter.rb`). Built directly, no
three-option comparison — reuses an existing pattern verbatim rather
than inventing a new one. Mockup at
[decisions/ux-pages/attendance-corrections.html](../ux-pages/attendance-corrections.html).

**Distinct from Time & Attendance:** `time-attendance.html`
([[time-attendance-attendance-first-templates-drawer]]) is the
HR-Admin/manager-facing Attendance Records page — approving or
rejecting a correction request happens there
(`Team::AttendanceCorrectionRequestsController#approve`/`#reject`
redirect back into it). This page is the other half: the employee who
*files* the request and checks its status. Neither page duplicates the
other's job.

**Layout — reused, not reinvented:** identical shape to
[[time-off-list-plus-modal|Time Off]] — request history is the default
view (comfortable-density table, four-category status badges), filing
a request is occasional so it lives behind a "Request a correction"
button that opens the same modal mechanism already established for My
Profile / Time Off / My Reviews.

**Fields, taken straight from the real form and model** (no invented
content):
- History table: Date, Requested clock in, Requested clock out, Reason,
  Status — same columns as
  `app/views/attendance_correction_requests/index.html.erb`.
- Modal form: Date, Corrected clock in (optional), Corrected clock out
  (optional), Reason (required) — same labels as
  `attendance_correction_requests/new.html.erb`. Approver note reuses
  Time Off's exact wording pattern ("Goes to {manager} for approval"),
  matching the real view's `current_employee.manager&.full_name || "an
  admin"` fallback.
- Validation demo: `AttendanceCorrectionRequest`'s own
  `requests_at_least_one_clock_time` model validation (must provide a
  corrected clock in or clock out) — shown inline under the two clock
  fields per [[form-validation-inline-only]], toggled by a demo-strip
  checkbox the same way Time Off demos its end-date error.

Approval stays single-level only, same as every other request type
([[../approval-chains-scrapped-fallback-design]]).
