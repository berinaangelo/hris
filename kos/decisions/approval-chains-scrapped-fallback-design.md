---
title: approval-chains-scrapped-fallback-design
tags: [hris, ruthless-simplicity, scope, scrapped]
date: 2026-08-21
---

Multi-step/configurable approval chains are scrapped for the HRIS project
(see [[../projects/hris/PLAN.md]]) — not on any roadmap tier, backlog
included. User confirmed from personal experience that single-manager
approval matches the common real-world case.

What it would have been: replacing the v1 single "employee submits →
manager approves" step with a *sequence* of approvals that can vary by
condition (HR co-sign, skip-level approval when a manager is
unavailable, different chains per request type/department). Rejected
because it means building a small workflow/rules engine — real
complexity, and speculative without an actual customer whose org
structure doesn't fit the single-approver model.

**Fallback design, on file for if a real customer ever forces the
issue** (deliberately capped, not a generic engine):
- Exactly two possible approvers, not N: `approver_1` (manager, as
  today) and an optional `approver_2`.
- One fixed trigger rule expressed as a single editable number (e.g.
  "requests over X days also need approver_2") — a setting, not a
  rule-builder UI. Same data-not-code principle as
  [[statutory-deductions-as-editable-data-not-code]].
- `approver_2` defaults to the employee's manager's manager — read
  directly off the org chart already in the system, no separate
  assignment screen.
- Same approve/reject mechanism, just run twice — no new state
  machinery.
- Automatic skip-level re-routing (detecting an unavailable manager) is
  skipped entirely — an HR manual-reassign button covers every "approver
  unavailable" edge case instead.
- Per-request-type or per-department chains stay out until a second real
  case proves the one-size shape is wrong.

If this ever gets built, re-justify it against a specific customer's
actual org structure at that time — don't build it because it was once
on a list.
