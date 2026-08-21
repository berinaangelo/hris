# Benefits — Plan

Status: post-MVP backlog — scoped, locked as record-keeping only
Last updated: 2026-08-21

## One-sentence description

The system records what benefit plan each employee is enrolled in, so
HR and the employee can see it — enrollment itself happens directly
with the carrier.

## In scope

`plan_name`, `provider`, `effectivity_date`, `dependents` (simple list)
per employee — HR types it in after enrolling someone through the
carrier. Viewable on the employee profile.

## Out of scope

Enrollment workflow, eligibility rules, cost-sharing computation, open
enrollment periods, claims/reimbursement tracking, carrier API
integrations.

## Why it's locked this way

See [[vendor-fragmented-features-record-keeping-only]] — benefits
administration is vendor-fragmented (every carrier has its own
enrollment form/rules, mostly no real API) and workflow-heavy in a way
that doesn't reduce to a lookup table the way statutory deductions do.
Default answer for this shape of problem: record the outcome, don't
build the process. Same treatment would apply if recruitment/ATS ever
needs to touch carrier-style external systems.

## Related decisions

- [[vendor-fragmented-features-record-keeping-only]]
