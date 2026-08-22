---
title: add-employee-split-live-preview
tags: [hris, design, ux, company, admin]
date: 2026-08-22
---

Chose "Split, Form + Live Preview" for the v1 Add Employee page — the
HR-Admin creation form reached from
[[people-directory-card-grid-with-list-toggle|People Directory]], the
"Add" step of the v1 primary flow (see
[[../projects/hris/PLAN.md|the plan]]) — over "Single-Page Form" (one
continuous scroll) and "Multi-Step Wizard" (guided steps with a Review
screen). Full comparison, all three built on the same tokens:
https://claude.ai/code/artifact/02a99f85-4fde-4306-ade3-0dcf9d7f614d

**Layout:**
- Left: the form, sectioned (Identity & Contact / Org Position /
  Starting Documents), inline validation per
  [[form-validation-inline-only]].
- Right: a live "Directory preview" card — the exact card this person
  will get in [[people-directory-card-grid-with-list-toggle|the People
  Directory's card view]] — updating as the form fills in, plus a
  compact fact list (manager, start date, employment type).
- Nothing is saved until "Add employee" is pressed; the preview is
  read-only feedback, not a second form.

Built on tokens already decided elsewhere:
[[color-palette-ink-and-amber|Ink & Amber]] palette,
[[type-system-neutral-and-efficient|Archivo/Work Sans/IBM Plex Mono]]
type, and the same `.person-card` shape as the People Directory mockup
so the preview genuinely matches what gets created.

**Carried over, not re-decided here — field scope:** this form
captures only what HR actually knows at hiring time: legal name, a
personal email (for the account-setup invite), and employment facts
(title, department, manager, start date, type). Birthdate, mobile,
home address, and emergency contact are left for the employee to fill
in on first login, per
[[my-profile-summary-plus-modal]]'s existing "employee edits
contact/emergency info" split. The onboarding checklist isn't
configured here — it's a fixed list auto-attached on creation, matching
the `Employees::AttachOnboardingChecklist` step in
[[../rails-thin-controllers-organizer-interactor-pattern]]. Starting
documents are optional at creation, addable later from
[[employee-detail-inline-edit-with-reserved-tabs|Employee Detail]].

Why this one: the plan's own god moment for this step is close to a
literal spec — "HR adds a hire once and it's correct everywhere, never
edited twice" — which makes getting it right on the first save more
important than raw form-filling speed. Showing the actual result (the
directory card, not just the raw inputs) is what catches a wrong
department or a misspelled title before it becomes the record every
other screen — approvals routing, leave balance, the org chart — relies
on. Single-Page Form was the cheapest build and arguably fine given how
few fields this actually has, but "showing the result before commit" is
worth the extra column for a record this consequential to get wrong.
Multi-Step Wizard's guidance was set aside as more ceremony than seven
fields need — the same "don't build more structure than the content
requires" reasoning already used against configurable approval chains
elsewhere in this project.

HTML mockup: [[../ux-pages/add-employee.html]]
