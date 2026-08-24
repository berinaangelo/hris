import { Controller } from "@hotwired/stimulus"

// Generic: submits the nearest form on `change`. Used by Account
// Settings' notification-preference toggles, which are instant-apply
// with no separate Save step — see
// kos/decisions/ui/account-settings-summary-plus-modal.md.
export default class extends Controller {
  submit() {
    this.element.closest("form").requestSubmit()
  }
}
