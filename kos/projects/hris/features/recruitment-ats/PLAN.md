# Recruitment/ATS — Plan

Status: post-MVP backlog — scoped, not committed to a version
Last updated: 2026-08-21

## One-sentence description

HR posts an opening, candidates apply through a public form, HR moves
each one through a few statuses, and marking someone "Hired" creates
their employee record.

## The hook that keeps this one narrative, not a bolted-on product

The payoff moment isn't a hiring funnel dashboard — it's that "Hired" is
the literal handoff into the employee system already built (see
[[../../PLAN.md|v1]]). Candidate data becomes employee profile data, no
retyping — the same "the right fact is already there" pattern as
everything else in this HRIS.

## Core flow

1. HR creates a job opening — title, description, open/closed status,
   public link.
2. Candidate applies via a public form — name, email, phone, resume
   upload, optional note. No account, no login (candidates aren't
   system users).
3. HR sees applicants per job in a fixed status list — New →
   Interviewing → Offer → Hired / Rejected (a dropdown, not a
   drag-and-drop pipeline builder).
4. HR marks someone Hired → system pre-fills a new employee record from
   their application (name, email, resume on file).
5. Rejected/closed candidates just sit in history — no further action
   needed.

## In scope

- Job opening (title, description, status, public URL)
- Public application form (fixed fields, file upload for resume)
- Fixed-stage status per candidate
- Free-text notes field per candidate (interview feedback, not a
  structured scorecard)
- Hired → auto-creates employee record

## Out of scope

- Job board syndication (LinkedIn/Indeed/JobStreet posting) — just your
  own public link
- Resume parsing/auto-fill — candidate fills the form manually
- Interview scheduling/calendar integration — coordinated outside the
  system
- Structured scorecards — a notes field covers it
- Offer letter generation/e-signature — external doc/email
- Referral programs, sourcing/candidate CRM, background checks
- Automated candidate emails/communication templates
- Hiring funnel analytics/dashboards
- Configurable pipeline stages per job — one fixed list for everyone
- Resume auto-scoring — see
  [[ats-checker-reuse-parked-for-recruitment]] for the existing tool
  that could bolt on here once this exists; not part of the initial
  build

## Related decisions

- [[ats-checker-reuse-parked-for-recruitment]]
