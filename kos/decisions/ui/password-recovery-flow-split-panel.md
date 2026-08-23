---
title: password-recovery-flow-split-panel
tags: [hris, design, ux, login, auth]
date: 2026-08-23
---

Chose "Split Panel" for the HRIS Forgot Password / Reset Password flow —
reusing [[login-page-split-panel|login-page.html's split panel]] outright
rather than comparing fresh options, per the user's own call: every
auth-adjacent screen inherits login's chosen layout instead of
re-litigating it per screen. Full comparison (built before that call,
kept for reference — Centered Card and Bare Minimum were also mocked up
but not evaluated on their own merits):
https://claude.ai/code/artifact/b88000eb-5fcc-47ac-ba9b-1fd5801b7ba7

**Two pages, one flow, both reusing login's exact chrome** (Ink & Amber
tokens, Archivo/Work Sans, Lucide-style icons,
[[../ui/form-validation-inline-only|inline-only]] validation timing):
- **Forgot password** (`/forgot-password`): brand pane left (headline +
  three security-reassurance bullets, replacing login's god-moments
  copy), work-email field right, "Send reset link" CTA, footer points
  back to sign in instead of forward to sign-up.
- **Reset password** (`/reset-password`, the page an emailed link lands
  on): same brand pane, new-password + confirm-password fields (both
  with the show/hide toggle reused from login's password field),
  "Reset password" CTA.

**New terminal states, not present on login** — built on the icon-circle
confirmation pattern first used in
[[job-application-form-split-panel|the job application form's submitted
state]] (itself per
[[empty-states-guided|decisions/ui/empty-states-guided.md]]: icon,
headline, one line, conditional CTA):
- **Link sent** (after requesting): "Check your email," non-committal on
  whether the address is on file.
- **Link expired** (reset page, invalid/stale token): caution-tinted
  icon-circle, "Request a new link" CTA back to the forgot-password page.
- **Password updated** (reset page, success): positive icon-circle,
  "Back to sign in" CTA.

**Not yet a decision, carried over as an open assumption:** whether the
request page discloses if an email is on file — shown here as the
standard non-disclosure wording ("if an account exists for that
email…"), consistent in spirit with
[[../security-practices-checklist|security-practices-checklist]] but not
spelled out there. Link expiry shown as 15 minutes, a placeholder
pending an actual policy decision. Request-page validation stays
format-only ("enter a valid work email"), deliberately not "no account
found," for the same non-disclosure reason.

HTML mockup: [[../ux-pages/password-recovery-flow.html]]
