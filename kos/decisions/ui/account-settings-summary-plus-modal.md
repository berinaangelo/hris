---
title: account-settings-summary-plus-modal
tags: [hris, design, ux, account, settings]
date: 2026-08-23
---

Employee self-service Account Settings (change password, notification
preferences) — under Me
([[navigation-me-team-company|navigation-me-team-company]]), reached
from the avatar menu rather than a new Me sub-tab since it's
account-level, not HR-record data. Not on the original roadmap, added
ad hoc like Org Chart, Offboarding, and Password Recovery.

Reuses [[my-profile-summary-plus-modal|My Profile's "Summary + modal"]]
pattern outright, per the user's own call — no fresh three-option
comparison, the same reuse-precedent as
[[password-recovery-flow-split-panel|Password Recovery reusing Login's
split panel]].

**Layout:**
- Left summary column: avatar, name, title/department, status badge,
  and account facts (employee ID, work email, password last changed,
  last login) — same shape as My Profile's summary column, swapping
  employment facts for account facts. Single "Change password" button.
- Right column: notification preferences as a flat list of
  always-visible toggle switches (leave request updates, new payslip
  available, review cycle reminders, company announcements). Toggling
  takes effect immediately, no save step — reuses
  [[thirteenth-month-toggle-inline-payout-preview|the 13th-month
  toggle's]] "the switch stays instant" precedent, since these are
  low-stakes, frequently-adjusted prefs.
- Modal (opened by "Change password"): current password, new password,
  confirm new password, Save/Cancel. Kept in a modal rather than inline
  because a password change is rare and sensitive enough to warrant a
  deliberate, separate action — same reasoning My Profile used for
  pulling contact-info edits out of the default view.

Built on tokens already decided elsewhere:
[[color-palette-ink-and-amber|Ink & Amber]] palette,
[[type-system-neutral-and-efficient|Archivo/Work Sans/IBM Plex Mono]]
type, [[badge-system-four-categories|four-category badges]] for the
Active status pill, and
[[form-validation-inline-only|inline-only]] validation inside the
password modal (passwords-don't-match error).

HTML mockup: [[../ux-pages/account-settings.html]]
