---
title: compliance-certifications-pinned-attention-full-list
tags: [hris, design, ux, company, admin, compliance]
date: 2026-08-22
---

Chose "Pinned Attention + Full List" for Compliance/Certifications — the
HR-Admin-only list under Company → Compliance (see
[[navigation-me-team-company]], post-MVP, customer-dependent
[[../projects/hris/features/compliance-certification-tracking/PLAN.md|compliance-certification-tracking]])
— over a plain "Flat Sorted List" and "Grouped by Urgency" (Expired /
Expiring soon / Valid as three separate sections, Valid collapsed).
Full comparison, same 10 certifications on identical tokens:
https://claude.ai/code/artifact/fa5cdff4-edc8-434e-af85-340ab357267b

**Layout — the chosen option:**
- A "Needs attention" strip pinned above the table, visible with zero
  scrolling: a horizontally-scrolling row of chips, one per
  Expired/Expiring-soon certification, each showing the employee, the
  cert name, and days overdue/remaining.
- Below it, the single list the plan itself asks for — one flat table,
  every certification, sorted ascending by expiry date, completely
  unmodified by the panel above it. The panel is a pure summary of rows
  already in the table, not a second data source.
- Status column carries a badge only for Expired (Negative) or
  Expiring soon within the fixed 30-day window (Caution); a valid
  certification shows no badge, per
  [[badge-system-four-categories]]'s "badges are for deviation" rule.
- Search box + status filter chips (All / Expired / Expiring soon /
  Valid) on the table, matching the toolbar pattern already used on
  [[people-directory-card-grid-with-list-toggle|People Directory]] and
  [[company-reviews-roster-filterable-grid-list|Company Reviews]].

Built on tokens already decided elsewhere:
[[color-palette-ink-and-amber|Ink & Amber]] palette,
[[type-system-neutral-and-efficient|Archivo/Work Sans/IBM Plex Mono]]
type, and [[data-tables-comfortable-density|comfortable table
density]].

**Carried over, not re-decided here:** two fields only —
`cert_name`, `expiry_date` — no issuing body, cert number, or document
upload; one fixed 30-day notice window, no per-cert configurable
windows; HR-only visibility, no employee-facing notification or
self-renewal flow; a heads-up list, not an enforcement/auto-suspension
mechanism — all per
[[../projects/hris/features/compliance-certification-tracking/PLAN.md]].
No row detail or edit modal wired in the mockup.

Why this one: the project's own design north star
([[../projects/hris/PLAN.md|v1 PLAN]]'s "god moments" section — the
right fact is already visible, with zero setup or asking around)
applies just as directly to this post-MVP screen as to any v1 one. The
fact this feature exists to surface is "who needs action" — a plain
sorted list technically contains that fact but still asks HR to read
down the Status column to find it; the pinned strip puts it in front
of them the instant the page loads. It does this without touching the
underlying list at all, so it keeps the plan's own literal framing
("one HR-facing list, sorted by soonest-expiring") completely intact —
unlike the urgency-grouped option, which reads as three lists instead
of one to get the same visibility. The cost is a small one: the five
at-risk rows appear in two visual forms (chip + table row), acceptable
for a feature the plan already frames as near-zero cost because it's
this minimal.

HTML mockup: [[../ux-pages/compliance-certifications.html]]
