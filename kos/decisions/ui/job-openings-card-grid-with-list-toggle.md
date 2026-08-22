---
title: job-openings-card-grid-with-list-toggle
tags: [hris, design, ux, company, admin, recruitment]
date: 2026-08-22
---

Chose "Card grid" for Job Openings — the HR-Admin landing page for
Recruitment (Company → Recruitment → Job Openings, post-MVP,
[[../projects/hris/features/recruitment-ats/PLAN.md]]) — over "Flat table +
toolbar" and "Open section + collapsible closed archive", with a card/list
view toggle added on top (card selected by default), reusing
[[people-directory-card-grid-with-list-toggle|People Directory]]'s exact
mechanic rather than inventing a new one. Full comparison, same nine
openings and figures on identical tokens:
https://claude.ai/code/artifact/61f41c5c-bff8-48e3-9042-371234746083

**Layout — the chosen option:**
- One card per opening (title, status badge, pipeline-stage counts — New /
  Interviewing / Offer / Hired / Rejected per the plan's fixed stages, a
  copy-link chip, "View pipeline") in a responsive grid, same card-grid
  language already shipped on
  [[people-directory-card-grid-with-list-toggle|People Directory]] and
  [[rate-tables-landing-cards-edit-drawer|Rate Tables]]. Closed postings
  stay in the grid, visually muted (`--surface` background) rather than
  hidden.
- A view-toggle control next to "New job opening" switches to a denser
  table (title/status/pipeline/posted/public link/actions columns) for
  scanning every posting at once — same two-icon toggle, same underlying
  radio-driven show/hide mechanic as People Directory's, applied here
  without modification.
- Clicking into any opening goes to Job Opening Detail + Candidate
  Pipeline, a separate not-yet-built page — nothing here edits a
  candidate's stage.

Built on tokens already decided elsewhere:
[[color-palette-ink-and-amber|Ink & Amber]] palette,
[[type-system-neutral-and-efficient|Archivo/Work Sans/IBM Plex Mono]] type,
[[badge-system-four-categories|four-category badges]] — Open reads
Positive (the wanted working state), Closed reads Neutral (no judgment on
filled vs. cancelled, that detail belongs on the Detail page).

**Carried over, not re-decided here:** public application links are
illustrative (`hris.app/careers/…`), no real subdomain wired. Pipeline
counts are illustrative placeholders, not computed. Unlike Payroll Runs,
more than one opening can be open at once, so there's no single pinned
"the one open run" to build a hero around — that's why the third option
(open section + collapsible closed archive) wasn't picked, even though it
reused a pattern from Compliance/Certifications.

Why this one: card grid was the second recommendation, picked over the
flat table (denser but less inviting for a screen HR won't visit often)
and the open/closed split (adds a click to reach history the user didn't
want gated). The list-view toggle wasn't part of the original three
options — added on request, reusing People Directory's already-decided
mechanic instead of proposing something new, since the same card-vs-list
trade-off already got made once for that screen.

HTML mockup: [[../ux-pages/job-openings.html]]
