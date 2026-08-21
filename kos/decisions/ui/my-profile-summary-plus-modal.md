---
title: my-profile-summary-plus-modal
tags: [hris, design, ux, profile]
date: 2026-08-21
---

Chose "Summary + Modal" for the v1 My Profile view/edit page — a
read-only summary column plus an edit modal — over "Single Edit
Toggle" (one button switches the whole personal-info section into a
form) and "Section Cards" (Contact and Emergency Contact each get
their own independent edit affordance). Full comparison, all three
built on the same tokens: https://claude.ai/code/artifact/48289218-3159-4e39-8550-8addc8eadd74

**Layout:**
- Left summary column (narrow, fixed): avatar, name, title/department,
  status badge, a compact fact list (employee ID, manager, start date,
  mobile, email), and a single "Edit personal info" button.
- Right column: Onboarding checklist and Documents cards, always
  visible, never part of the modal.
- Modal (opened by the edit button): personal email, mobile number,
  home address, emergency contact name/phone — the only fields an
  employee edits directly — with Save/Cancel.
- Employment facts (job title, department, manager, start date) stay
  HR-managed and read-only, shown only in the summary column, never
  editable from this page.

Built on tokens already decided elsewhere:
[[color-palette-ink-and-amber|Ink & Amber]] palette,
[[type-system-neutral-and-efficient|Archivo/Work Sans/IBM Plex Mono]]
type, [[badge-system-four-categories|four-category badges]] for
onboarding checklist status, and
[[form-validation-inline-only|inline-only]] validation inside the
modal form.

**Confirmed, not just assumed:** the field split — HR owns employment
facts, the employee edits only contact and emergency-contact info — is
the actual policy, not a placeholder. Fixed schema throughout per the
v1 [[../projects/hris/PLAN.md|PLAN]]'s "not a custom-field builder":
no per-company or per-field configuration.

Why this one: keeps the default page calm and read-only — day to day,
an employee just needs to see their info is already correct, matching
the plan's god moment that a login should already show the right
facts rather than ask the user to go looking. Editing is a deliberate,
infrequent side task pulled out of the main flow rather than a mode
the whole page sits in. Costs a modal component no other v1 screen
otherwise requires, and adds one extra click/context switch versus
Single Edit Toggle for what's usually a small edit — accepted
specifically because edits here are expected to be rare (a phone
number or address changing) rather than routine.

Single Edit Toggle was the cheaper build (one form, one submit) but
makes the whole page carry edit-mode chrome for what's a rare action.
Section Cards solved the same "HR data vs. self-managed data" split
this option solves, but at the cost of two independent mini-forms and
two save states — a second validation surface the project has avoided
elsewhere (see [[form-validation-inline-only]]'s reasoning against a
second, drifting validation system).

HTML mockup: [[../ux-pages/my-profile.html]]
