---
title: badge-system-four-categories
tags: [hris, design, color]
date: 2026-08-21
---

Confirmed a single badge/status system for the HRIS — four semantic
categories reused across every feature's statuses, instead of one color
per status word. Full spec with usage across leave, payroll, recruitment,
PIP, loans, and certifications:
https://claude.ai/code/artifact/eaf903b8-bd1c-43be-b7f5-7fe9f3896188

**The four categories** (soft tinted fill, never solid — badges are
read-only status, styled distinct from solid-fill action buttons; text
in IBM Plex Mono, uppercase, per
[[type-system-neutral-and-efficient|the type system]]):

| Category | Meaning | Background | Text |
|---|---|---|---|
| Positive | done, succeeded | `#E7F6EC` | `#14532D` |
| Caution | pending, in progress, needs attention | `#FEF3E2` | `#78350F` |
| Negative | stopped, failed | `#FCE8E8` | `#7F1D1D` |
| Neutral | informational, no judgment attached | `#E9ECF1` | `#24344C` |

Text colors were darkened from the first draft after a contrast pass —
backgrounds unchanged.

**Mapping:**
- Leave request: Pending → Caution, Approved → Positive, Rejected → Negative
- Payroll run: Open → Neutral, Finalized → Positive
- Recruitment pipeline: New → Neutral, Interviewing/Offer → Caution, Hired → Positive, Rejected → Negative
- Performance review (PIP outcome): Passed → Positive, Not Passed → Negative, Extended → Caution
- "On PIP" profile flag → Caution
- Loan: Active → Neutral, Paid off → Positive

**Rule:** badges are for deviation, not every state. Certifications and
employee status show no badge in their normal state (valid cert, active
employee) — a badge appears only for Expiring soon/Expired (Caution/
Negative) or Offboarded (Neutral). Recruitment and PIP are the
exception: every value gets a badge there, since the badge is the
primary way those pipelines are read at a glance.

See [[dark-mode-deferred-tokenize-colors-now]] — these four categories
should be implemented as named tokens, same reasoning as the base
palette.
