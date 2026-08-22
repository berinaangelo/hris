---
title: job-application-form-split-panel
tags: [hris, design, ux, recruitment, public]
date: 2026-08-22
---

Chose "Split panel — job details + form" for the public Job Application
Form — the actual candidate-facing page from
[[../projects/hris/features/recruitment-ats/PLAN.md]]'s core flow step 2
("candidate applies via that form") — over "Single page, job context on
top" and "Multi-step progressive form". Full comparison, same job (Senior
Backend Engineer at a placeholder employer) on identical tokens:
https://claude.ai/code/artifact/c34e4657-69e2-4575-8ade-88235646749a

**Layout — the chosen option:**
- Reuses [[login-page-split-panel|Login]]'s exact brand-pane + form-pane
  mechanic — the only other unauthenticated page in the system. Left pane
  (dark, Ink & Amber) carries the employer's job posting: title, location,
  full description, a few "why work here" perks. Right pane (white) holds
  the form: full name, email, phone, résumé dropzone, optional note,
  Submit — the plan's fixed field list exactly.
- No internal HRIS chrome at all — no nav tabs, no avatar, no "Company →"
  breadcrumb. This is the one page in the system a non-employee sees.
- A Data Privacy Act (RA 10173) consent checkbox is included but was not
  in the plan's fixed field list — added as a common PH requirement for
  forms collecting personal data, flagged for confirmation rather than
  assumed decided.
- A confirmation state (icon, headline, one line, no CTA — nothing left
  to do — per [[empty-states-guided]]) replaces the form pane after
  submit.

**Carried over, not re-decided here:** the page's own branding is
illustrative ("Alon Pay," a placeholder PH fintech employer) — in
production this is white-labeled to whichever SME posted the job, not to
HRIS's own [[color-palette-ink-and-amber|Ink & Amber]] palette; that
palette was only kept here so the three options compared on identical
tokens. Résumé upload is a static dropzone mock, not a working file
picker. Inline validation follows
[[form-validation-inline-only|the existing decision]] — no live-blur
layer.

Why this one: the job description and a few concrete perks stay visible
the entire time the candidate fills in the form — no scrolling back and
forth between reading the posting and answering it — which matters most
here since, unlike an internal HRIS screen an employee already knows how
to use, this is a stranger's one-shot, unauthenticated interaction with
the company. Picked over the single-page option (simplest to build, but
a long description can push the form below the fold, especially on
mobile) and the multi-step wizard (built-in review step catches typos,
but adds two extra clicks to what's fundamentally a five-field form, and
its confirmation is just its natural last step rather than a separate
state). The split's own known trade-off — panes stack on mobile, losing
the side-by-side benefit exactly where most candidates likely apply from
— is accepted as-is, same trade already made for Login.

HTML mockup: [[../ux-pages/job-application-form.html]]
