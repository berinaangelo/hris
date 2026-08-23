---
title: compliance-certification-form-right-side-drawer
tags: [hris, design, company-tab, compliance]
date: 2026-08-23
---

Add/Edit Certification — the form behind "Add certification" and each
row's "Edit" on
[[compliance-certifications-pinned-attention-full-list|Compliance/
Certifications]], left explicitly unwired when that page was decided
("No row detail or edit modal wired in the mockup"). Built directly, no
three-option comparison, per the user's own call. Mockup at
[decisions/ux-pages/compliance-certification-form.html](../ux-pages/compliance-certification-form.html).

Right-side drawer (11th reuse of the mechanic — Payroll Run Detail,
Time & Attendance, Rate Tables, Loan Ledger, Hired Handoff, Job Opening
Form, Offboarding, Roles & Access), directly editable with no separate
view/edit toggle since opening it already signals intent — same
reasoning as Rate Tables' drawer option. Add and Edit share one layout;
Edit is shown prefilled (Isabel Torres's CPA License Renewal, an actual
"Expiring soon" row from the list) with a Delete action added, matching
the Add/Edit form precedent set by
[[job-opening-form-right-side-drawer]].

**Fields — same two carried over, nothing added:** employee (select)
and certification name (text), plus expiry date. No issuing body, cert
number, or document upload — the list decision's scope was explicit
about this and the form doesn't reopen it. Expiry date drives the
Status badge automatically (Expiring soon inside the fixed 30-day
window, Expired once past), so the form doesn't ask for or store a
status separately.

**Delete, no archive:** removing a certification deletes the record
outright — the underlying list has no version history, so there's
nothing to soft-delete or restore.
