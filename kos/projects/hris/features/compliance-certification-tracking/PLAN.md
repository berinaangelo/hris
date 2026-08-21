# Compliance/Certification Tracking — Plan

Status: post-MVP backlog — scoped, customer-dependent (build only if a
  target customer has licensed staff)
Last updated: 2026-08-21

## One-sentence description

The system stores each employee's certification expiry date and
notifies HR before it lapses, so nobody has to remember to check.

## Core flow

HR adds a certification to an employee's profile (name, expiry date) →
a daily check looks for anything expiring within 30 days → HR gets
notified → HR updates the expiry date once renewed → done.

## Why it's cheap regardless of value

Two fields, one scheduled job, one list view — reuses the notification
system already built for leave-request approvals (see
[[../../PLAN.md|v1]]), just triggered by date proximity instead of an
approval event. The cost side of building this is close to zero; the
only real question is whether any target customer has licensed staff
(healthcare, transport, security, or any licensed trade) at all.

## In scope

- `cert_name`, `expiry_date` per employee — the minimum that makes the
  feature work at all
- Daily scheduled check against `expiry_date`
- One HR-facing list, sorted by soonest-expiring

## Out of scope, even within this "simple" feature

- `issuing_body`, `cert_number`, document upload — informational
  nice-to-haves, add only if a customer specifically asks for the
  paper trail
- Configurable notice windows (30/60/90 days, per cert type) — hardcode
  one window (e.g. 30 days), no settings screen
- Employee-facing notification/self-renewal request flow — HR-only
  visibility is enough
- Auto-suspension or blocking logic elsewhere in the system — stays a
  heads-up, not an enforcement mechanism
