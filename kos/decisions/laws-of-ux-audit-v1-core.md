---
title: laws-of-ux-audit-v1-core
tags: [hris, ux, laws-of-ux, audit]
date: 2026-08-23
---

Fresh usability pass against the Laws of UX (Jakob's, Fitts's, Hick's,
Miller's, Gestalt proximity/similarity/common-region, Von Restorff,
Peak-End, Tesler's, Zeigarnik, Doherty Threshold) over the 11 v1-core
mockups — the ones with a working Rails backend behind them today.
Not re-litigating any layout choice a linked decision doc already made
for a stated reason; this only flags what those docs didn't already
weigh. Screenshotted each mockup directly (including the interactive
states gated behind the demo checkboxes — the drawer/modal/error
previews) rather than reading markup alone, since several real findings
below only show up once a state actually renders.

Two real violations found, both evidence-based; everything else on the
primary v1 flow (login → dashboard → time off → approvals → people →
org chart → offboarding) reads clean. **Both fixed the same day**, in
the mockup HTML itself — see each section below for what changed.

## [[ui/time-off-list-plus-modal|time-off.html]]

Checked: the default history view, and the "Request time off" modal in
both its normal and validation-error states (end-date-before-start-date,
per [[ui/form-validation-inline-only]]).

**Violation — modal footer breaks its own boundary under real content
height.** With the validation error showing and the "Reason" field
filled in (both realistic states, not edge cases — a validation error
is the literal reason this modal has an error path at all), the
modal's own white background ends before its content does: the
Cancel/Submit request button row sits at the same vertical position as
the Request History table behind it, and that table's text ("Vacation
Leave," "APPROVED") is visible bleeding through right at the button
row. This breaks the Law of Common Region — a modal's whole job is to
visually contain its content inside one boundary, and here the
boundary is shorter than the content once an error message and a
non-trivial Reason value both stack in. It also lands on the Submit
button specifically, at exactly the moment (a validation error) Peak-
End Rule says deserves the most design care, not less legibility.

**Fixed.** Root cause turned out to be more specific than "needs a
bigger max-height": `.modal-box` had `align-items: center` on its flex
parent (`.modal-overlay`) plus a percentage `max-height` — a "center"-
aligned flex item that overflows its container doesn't reliably get
scrollable/clippable overflow (browsers only add scrollable area on the
"safe" side of an unsafe-centered item), so content could paint past
the box's edge with no scrollbar to reach it and no clipping to hide
it. Confirmed with `overflow: hidden !important` and even `contain:
paint !important` — neither clipped it, which is what pointed at the
alignment interaction rather than a simple sizing fix. Changed
`.modal-overlay` to `align-items: flex-start` with `overflow-y: auto`
on the overlay itself, and let `.modal-box` size to its own content
instead of fighting it with `max-height`. Verified: the error+long-
reason state now renders with Cancel/Submit fully inside the box, and
the default (no-error) state is visually unchanged.

Not a new finding, but relevant context: [[ui/time-off-list-plus-modal]]
already weighed and accepted the modal mechanism itself (reusing
[[ui/my-profile-summary-plus-modal|My Profile's]] pattern) — this is a
sizing bug in that implementation, not a case against the modal choice.

## [[ui/home-dashboard-balance-led-hero|home-dashboard.html]]

Checked: the balance hero, "My requests" table, and the sidebar cards
(At a glance / Attendance / manager approvals nudge).

No significant findings. The hero keeps one accent color on one CTA
(Von Restorff used correctly — "Request time off" is the only amber
element on the screen), the three sidebar cards use Common Region
consistently (each its own bordered card), and status badges
(Pending/Approved/Rejected) are color-consistent with
[[ui/badge-system-four-categories]] throughout.

## [[ui/team-approvals-inbox-inline-actions|team-approvals.html]]

Checked: the pending-request rows and the "Recently decided" table.

No significant findings — this is the strongest page of the eleven.
Approve/Reject sit directly on each row next to the exact facts needed
to decide (name, leave type, dates, balance), which is Fitts's Law
applied about as well as it can be: zero distance between the decision
inputs and the action. The low-balance caution chip on Grace Lim's row
("would leave 1.5") surfaces risk via proximity and color exactly where
the decision is being made, not as a separate warning elsewhere.
Approve (solid) vs. Reject (outline) is a clean Von Restorff/Law-of-
Similarity pairing — differentiated enough to avoid mis-clicks, without
hiding Reject.

## [[ui/people-directory-card-grid-with-list-toggle|people-directory.html]]

Checked: the default card grid, the toolbar (search, department chips,
view toggle, Add Employee), and the Offboarding-badge row (Jonas
Rivera).

No significant findings. The toolbar's 8-ish interactive elements read
as three chunked groups (search / filters / view+add) via spacing, not
one flat Hick's-Law choice set. Each employee's own card is a clean
Common Region grouping, and Jonas Rivera's "OFFBOARDING" badge
occupies the same card slot every other card uses for the tenure year
— consistent template, not a special-cased layout.

## [[ui/add-employee-split-live-preview|add-employee.html]]

Checked: the two-section form (Identity & contact / Org position),
Starting documents, and the live Directory preview panel.

No significant findings. Fields are chunked into two headed groups of
2–3 fields each (comfortably inside Miller's Law), and the live preview
panel is a genuinely good Tesler's Law trade — showing the actual
result before commit absorbs the "did I get the department/title
right" complexity into the interface instead of leaving HR to catch it
after the fact on People Directory.

## [[ui/employee-detail-inline-edit-with-reserved-tabs|employee-detail.html]]

Checked: the Personal & Contact / Org Position sections (including
their pencil-edit affordance), the Onboarding Checklist, Documents, and
the header (status, Offboard entry point).

**Violation — the edit affordance is a small, position-fixed icon
decoupled from the content it edits, and it's inconsistent with this
same product's own established pattern.** Each section's pencil icon
sits only at the top-right of that section's heading; "Personal &
Contact" alone spans ~250px down to Home address, so editing that one
field means traveling back up to a ~20px icon that isn't near it — a
straightforward Fitts's Law cost (small target, real distance from the
content in question). More telling: [[ui/my-profile-summary-plus-modal|My
Profile]] and [[ui/account-settings-summary-plus-modal|Account Settings]]
both solve the identical "edit my info" problem with one large,
full-width, unmissable "Edit personal info" / "Change password"
button. A user who's already learned that pattern elsewhere in this
exact app (Jakob's Law — *this app's* own prior screens set the
expectation) hits a smaller, easier-to-miss control here for a
conceptually similar action, on the one page in the app where getting
it right matters most (this is the HR-editable copy of the record).

**Fixed.** Converted both icon-only `.edit-pencil` controls into
`.btn-ghost` labels reading "Edit" with the same pencil icon — reusing,
verbatim, the exact button component this same page's own Documents
section already uses for "Upload" (same section-head slot, same
weight), so the fix didn't invent a new pattern, it just applied one
already present two sections down. The now-unused `.edit-pencil` CSS
rule was removed rather than left dead.

**Minor, secondary note — fixed too.** The "Offboard" action in the
header was plain red text sitting at the same size/weight as the
"Active" status label directly next to it (`EMP-0089  Active
Offboard`), under-differentiating the one genuinely consequential,
hard-to-reverse action on the page (a mild Von Restorff
under-application). Added a thin vertical divider between the status
facts and the Offboard button — `.identity-meta-divider`, 1px, using
the existing `--border` token — enough separation to read as "a
different kind of thing," without making a destructive-feeling action
falsely loud.

## [[ui/my-profile-summary-plus-modal|my-profile.html]]

Checked: the summary column, "Edit personal info" button, Onboarding
Checklist, and Documents.

No significant findings — and worth calling out as the positive
counter-example to Employee Detail's finding above: one clear,
full-width, high-contrast edit action for the one thing this page lets
you change. Download vs. download+replace icon pairing on the two
Documents rows (HR-uploaded vs. self-uploaded) correctly uses Law of
Similarity to signal different capability without a text label.

## [[ui/account-settings-summary-plus-modal|account-settings.html]]

Checked: the summary column, notification toggles, and the "Change
password" modal in its error state (mismatched confirmation).

No significant findings. The instant-toggle notification switches are
explicitly labeled "no separate save" right in the section copy,
correctly avoiding a Zeigarnik-Effect concern (no lingering unsaved
state to forget about). The password-mismatch error is a strong
example done right: red border on the specific field, error text
directly beneath it, nothing else on the modal disturbed — colocated,
specific, immediate.

## [[ui/org-chart-classic-top-down-tree|org-chart.html]]

Checked: the tree (root + 4 department-head cards) and its
expand/collapse interaction.

**Minor finding — the interaction relies on instructional copy rather
than being fully self-evident.** The page carries explanatory text
above the diagram ("Click a manager card to collapse or expand their
branch") because the click target is the entire card, not just the
chevron icon on it. "Org chart" already sets a static-diagram
expectation by Jakob's Law — this page has to actively teach its way
past that default rather than the chevron affordance alone carrying
it. The chevron itself is a reasonable, recognizable signal (tree-view
convention), and making the whole card clickable is a genuine Fitts's
Law win (a much larger target than the icon alone) — so this is a
minor point, not a real usability blocker, but it's evidence the
affordance doesn't fully speak for itself without the hint text
alongside it.

Not a new finding: the "small headcount fits on one screen without
collapsing anything by default" tradeoff was already flagged as a
scale risk in [[ui/org-chart-classic-top-down-tree]] itself — not
re-raised here.

## [[ui/offboarding-flow-schedule-clearance-tracker|offboarding-flow.html]]

Checked: all three states — the "Schedule offboarding" drawer, the
in-progress Separation tracker (Offboarding status), and the terminal
Offboarded confirmation.

No significant findings — this is the second-strongest page after
Team Approvals, particularly on Peak-End Rule. The in-progress state
proactively explains the gate before the user hits it ("'Mark
offboarded' unlocks once the day passes and everything below is
done."), which heads off a confused click on a disabled button rather
than letting the user discover the rule by trial and error. The
terminal state is calm and conclusive ("Offboarded effective Sep 15,
2026. Clearance closed out, record locked for edits.") — real care put
into the ending of what is, for the people involved, not a small
moment.

One thing outside this audit's scope but worth flagging since it
surfaced during review: the rendered clearance checklist shows 5 items
(Exit interview completed, Knowledge transfer notes filed, Company
equipment returned, System access revoked, Final pay & clearance
computed), while this same page's own header text describes "a
four-item clearance checklist" and names only 4 of those 5. Content/
spec mismatch, not a Laws-of-UX violation — flagged for whoever
reconciles [[ui/offboarding-flow-schedule-clearance-tracker]] against the
actual markup, not acted on here.

## [[ui/login-page-split-panel|login-page.html]]

Checked: the split-panel layout, form fields, and the god-moments copy
on the brand pane.

No significant findings. Standard, recognizable login pattern (Jakob's
Law working in the design's favor — no invented interaction for
something users already know), one full-width primary CTA, minimal
choice count (Hick's Law: two fields, two links, one button).

## Related decisions

- [[../projects/hris/PLAN.md]]
