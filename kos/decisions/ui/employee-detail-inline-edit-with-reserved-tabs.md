---
title: employee-detail-inline-edit-with-reserved-tabs
tags: [hris, design, ux, company, admin]
date: 2026-08-22
---

Chose a hybrid of "Inline Edit Per Section" for the v1 Employee Detail
page — the HR-Admin record view reached from
[[people-directory-card-grid-with-list-toggle|People Directory]] — over
a plain "Summary + Modal" (one modal covering every field) and plain
"Tabbed Sections" (Profile/Org Position/Documents/Onboarding each
behind their own tab). Full comparison, all three built on the same
tokens: https://claude.ai/code/artifact/9b403194-a7b5-4931-9c84-43790c7cab5c

**Layout — the hybrid:**
- A top-level "Profile" tab holds today's four v1 sections (Personal &
  Contact, Org Position, Onboarding Checklist, Documents) on one
  continuous page — nothing hidden behind a click just to see it. Each
  section has its own pencil-edit affordance, switching just that
  section into inline edit mode — no modal.
- "Loan Ledger" and "Benefits" sit as their own reserved top-level tabs
  for when Payroll v2 and the Benefits post-MVP feature land (see the
  [[../projects/hris/PLAN.md|roadmap tiers]]) — shown here as guided
  placeholders ("not available yet" + which tier it ships in), styled
  per [[empty-states-guided]]'s icon+headline+subtext shape though this
  is a roadmap placeholder, not a true empty state.
- Status shows no badge for the default "Active" state — only
  "Offboarded" would get one, per
  [[badge-system-four-categories]]'s "badges are for deviation, not
  every state" rule.

Built on tokens already decided elsewhere:
[[color-palette-ink-and-amber|Ink & Amber]] palette,
[[type-system-neutral-and-efficient|Archivo/Work Sans/IBM Plex Mono]]
type, [[badge-system-four-categories|four-category badges]], and the
same identity-strip/field-grid/checklist/document components already
built for [[my-profile-summary-plus-modal|My Profile]].

**Carried over, not re-decided here:** same fixed-schema rule as My
Profile — no per-company/per-field configuration. Content mirrors My
Profile's own Mikaela Santos exactly (same Employee ID) for
continuity, now with HR editing rights on employment facts too,
matching [[../projects/hris/PLAN.md|the plan's]] "HR adds a hire once
and it's correct everywhere." "Offboard employee" is an entry point
only, no flow behind it yet.

Why this one: asked directly which option best served the god-moments
principle ("the right fact is already visible, with zero setup or
asking around"), plain Tabbed Sections works against it — at any given
moment three-quarters of the record is hidden behind an unselected
tab, the "asking around" the principle exists to avoid. Plain Inline
Edit Per Section solves that but has no answer for where genuinely
separate future modules (Loan Ledger, Benefits) go without either
cramming them onto the same scroll or losing the "everything visible"
property once they land. The hybrid keeps tabs, but reserves them only
for content that's actually a different module — today's closely
related employee facts stay together on one page, inline-editable in
place, while Loan Ledger and Benefits get dedicated space exactly when
they're real.

HTML mockup: [[../ux-pages/employee-detail.html]]
