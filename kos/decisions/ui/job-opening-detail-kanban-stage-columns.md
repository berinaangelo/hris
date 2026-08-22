---
title: job-opening-detail-kanban-stage-columns
tags: [hris, design, ux, company, admin, recruitment]
date: 2026-08-22
---

Chose "Kanban-style stage columns" for Job Opening Detail + Candidate
Pipeline — where "View pipeline" from
[[job-openings-card-grid-with-list-toggle|Job Openings]] lands (Company →
Recruitment → Job Openings → an opening,
[[../projects/hris/features/recruitment-ats/PLAN.md]]) — over "Flat
filterable table" and "Split roster + candidate detail". Full comparison,
same opening (Senior Backend Engineer) and same ten candidates on identical
tokens: https://claude.ai/code/artifact/69c2aeb0-a9e1-402e-9aba-d379af71610f

**Layout — the chosen option:**
- Opening header (title, Open/Closed badge, description, posted date,
  public link chip, Edit opening / Close posting) plus a pipeline-count
  summary line, shared across all three options.
- Five columns — New, Interviewing, Offer, Hired, Rejected, the plan's own
  fixed stage list — each holding a compact candidate card (name, applied
  recency, email, a 2-line note excerpt).
- Stage changes through a per-card `<select>` dropdown, never drag-and-drop
  — matches the plan's own explicit wording ("a dropdown, not a
  drag-and-drop pipeline builder"). Dropdowns are colored per
  [[badge-system-four-categories|the badge system]]'s own Recruitment
  mapping: New → Neutral, Interviewing/Offer → Caution, Hired → Positive,
  Rejected → Negative.
- Offer-stage cards get a "Mark Hired" primary button instead of a plain
  "View" ghost button. Hired cards show a distinct positive-colored
  "Employee record created" tag — the plan's actual payoff moment (Hired →
  auto-creates the employee record) gets its own visual treatment instead
  of just another badge.

Built on tokens already decided elsewhere:
[[color-palette-ink-and-amber|Ink & Amber]] palette,
[[type-system-neutral-and-efficient|Archivo/Work Sans/IBM Plex Mono]] type,
[[badge-system-four-categories|four-category badges]].

**Carried over, not re-decided here:** résumé links and the public
application link stay illustrative, no file storage or real subdomain
wired. The confirmation step before Mark Hired actually creates the
employee record is out of scope for this layout comparison — assumed to be
a lightweight confirm dialog, not modeled. Per-candidate notes are the
plan's free-text field (interview feedback), not a structured scorecard.

Why this one: the pipeline's shape — how many candidates are sitting at
each stage — is visible at a glance across all five stages without opening
anything, matching how HR actually thinks about a hiring pipeline. Picked
over the flat table (denser and reuses more existing pattern, but hides
pipeline shape entirely behind a Stage column) and the split roster+detail
(best for reading one candidate's full notes, but only shows one candidate
at a time, making side-by-side comparison — e.g. two Offer-stage
candidates — slower). The five-column layout needs horizontal scroll under
~1080px and each card fits only a two-line note; a fuller per-candidate
view (full notes, résumé, contact card) isn't modeled behind these cards
yet — worth revisiting if HR needs to read long interview feedback often.

HTML mockup: [[../ux-pages/job-opening-detail.html]]
