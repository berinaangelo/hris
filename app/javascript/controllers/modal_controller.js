import { Controller } from "@hotwired/stimulus"

// Reusable modal — a native <dialog> wrapped in a minimal Stimulus
// controller. Kept intentionally thin: <dialog> already provides focus
// trapping, Esc-to-close, and a ::backdrop pseudo-element natively, so
// there's nothing to reimplement beyond open/close and backdrop-click.
// First use: Company Reviews' per-employee detail — see
// kos/decisions/ui/company-reviews-roster-filterable-grid-list.md and
// app/views/shared/_modal.html.erb.
export default class extends Controller {
  static targets = ["dialog"]
  static values = { open: Boolean }

  // Lets the server force this modal open on connect — e.g. a failed
  // form submit re-renders the page with data-modal-open-value="true"
  // so the validation errors are visible again instead of silently
  // dropped behind a closed dialog. See
  // kos/decisions/ui/account-settings-summary-plus-modal.md and
  // kos/decisions/ui/my-profile-summary-plus-modal.md.
  connect() {
    if (this.openValue) this.open()
  }

  open() {
    this.dialogTarget.showModal()
  }

  close() {
    this.dialogTarget.close()
  }

  // Clicking the ::backdrop delivers a click event targeting the
  // <dialog> element itself (it has no real DOM node of its own);
  // clicking inside the dialog's content targets a descendant instead.
  closeOnBackdrop(event) {
    if (event.target === this.dialogTarget) this.close()
  }
}
