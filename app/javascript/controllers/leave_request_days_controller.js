import { Controller } from "@hotwired/stimulus"

// Auto-computes the day count for a time-off request from its date
// range — a display convenience, not a validation layer. See
// kos/decisions/ui/time-off-list-plus-modal.md (the mockup shows no
// manual days input) and kos/decisions/ui/form-validation-inline-only.md
// (the actual end-before-start check stays server-side, round-trip).
export default class extends Controller {
  static targets = ["start", "end", "days", "usesCount"]

  connect() {
    this.recompute()
  }

  recompute() {
    const days = this.calculateDays(this.startTarget.value, this.endTarget.value)

    this.daysTarget.value = days
    if (this.hasUsesCountTarget) this.usesCountTarget.textContent = days
  }

  calculateDays(start, end) {
    if (!start || !end) return 0

    const startDate = new Date(`${start}T00:00:00`)
    const endDate = new Date(`${end}T00:00:00`)
    if (Number.isNaN(startDate.getTime()) || Number.isNaN(endDate.getTime())) return 0
    if (endDate < startDate) return 0

    const oneDay = 24 * 60 * 60 * 1000
    return Math.round((endDate - startDate) / oneDay) + 1
  }
}
