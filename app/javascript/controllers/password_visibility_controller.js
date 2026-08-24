import { Controller } from "@hotwired/stimulus"

// Toggles a password <input> between type="password"/"text" and swaps
// the eye/eye-off icon — see kos/decisions/ui/login-page-split-panel.md
// and kos/decisions/ui/password-recovery-flow-split-panel.md. Used on
// login, reset-password, and the Account Settings change-password modal.
export default class extends Controller {
  static targets = ["input", "icon"]

  toggle() {
    const hidden = this.inputTarget.type === "password"
    this.inputTarget.type = hidden ? "text" : "password"
    this.element.setAttribute("aria-label", hidden ? "Hide password" : "Show password")
  }
}
