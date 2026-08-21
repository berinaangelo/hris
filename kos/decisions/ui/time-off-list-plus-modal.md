---
title: time-off-list-plus-modal
tags: [hris, design, ux, time-off, leave]
date: 2026-08-21
---

Chose "List + Modal Form" for the v1 Time Off page — request history as
the default view, with "Request time off" opening a modal form — over
"Split Panel, Always-On Form" (a permanent compose column beside the
history table) and "Segmented Request / History" (a toggle between two
full-width views). Full comparison, all three built on the same tokens:
https://claude.ai/code/artifact/ac0fa452-f6db-46b4-beb6-cf7f2602e978

**Layout:**
- Top: leave balance card (figure + usage meter) and the "Request time
  off" button, always visible above the history table — no click needed
  to see the balance itself, only to open the request form.
- Below: request history table (submitted date, dates, type, days,
  status badge), comfortable density per
  [[data-tables-comfortable-density]].
- Modal (opened by the button): leave type, start/end date, a balance
  reminder line ("12.5 days remaining · this request uses 3"), an
  optional reason field, and a fixed approver note ("Goes to {manager}
  for approval") reflecting single-level-only approval per
  [[../approval-chains-scrapped-fallback-design]].

Built on tokens already decided elsewhere:
[[color-palette-ink-and-amber|Ink & Amber]] palette,
[[type-system-neutral-and-efficient|Archivo/Work Sans/IBM Plex Mono]]
type, [[badge-system-four-categories|four-category badges]] for request
status, [[data-tables-comfortable-density|comfortable table density]],
and [[form-validation-inline-only|inline-only]] validation inside the
modal form.

**Not yet a decision, carried over as an open assumption:** the leave
type list (Vacation, Sick, Emergency, Others) and whether "Reason" is
required rather than optional are placeholder content, not policy —
same status as the balance figures themselves (see
[[home-dashboard-balance-led-hero]]).

Why this one: reuses the modal mechanism already chosen for
[[my-profile-summary-plus-modal|My Profile]], so the product gains no
second dialog pattern to build or maintain — request-filing is an
occasional action, and history-checking is the common one, so history
gets the default screen real estate. The balance still satisfies the
plan's god moment without waiting for the modal: it's shown at the top
of the page before any click, and repeated inline in the modal next to
the date fields, right where the employee is about to commit to a
request.

Split Panel was the most literal read of "balance visible before
requesting" — nothing is ever a click away — but permanently spends
screen space (and pushes the history table below the form on narrow
screens) on an action most sessions never take. Segmented Request /
History solved the narrow-screen problem better and needs no dialog
component either, but costs a second click to get back to history after
filing a request, and reads less like the rest of v1's desktop-first
screens (Home, My Profile) than the other two.

HTML mockup: [[../ux-pages/time-off.html]]
