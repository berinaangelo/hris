import { Controller } from "@hotwired/stimulus"

// Drives the small track/fill bar next to Team Reviews' editable KPI
// score <select> (1-5), so the manager sees the same fig+bar language
// used by the read-only score display (see _kpi_table.html.erb's
// compact: true branch) while still scoring. See
// kos/decisions/ui/team-reviews-split-editable-detail.md.
export default class extends Controller {
  static targets = ["select", "fill"]

  connect() {
    this.sync()
  }

  sync() {
    const score = Number(this.selectTarget.value) || 0
    this.fillTarget.style.width = `${(score / 5) * 100}%`
  }
}
