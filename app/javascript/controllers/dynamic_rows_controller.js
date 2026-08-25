import { Controller } from "@hotwired/stimulus"

// Generic add/remove-row controller for any table backed by a
// `field[][subfield]` array-of-hashes param — clone a <template> row,
// remove a row, keep min/max bounds. First use: 3-5 KPI rows on the Team
// Reviews open-cycle/attach-KPIs forms (client-side min/max are UX
// guardrails only there — the real gate is
// ReviewCycles::CreateKpiEntries' own count check). Reused for Rate
// Tables' bracket rows — see
// kos/decisions/ui/rate-tables-landing-cards-edit-drawer.md.
export default class extends Controller {
  static targets = ["rows", "template", "addButton", "removeButton"]
  static values = { min: Number, max: Number }

  connect() {
    this.refreshButtons()
  }

  add() {
    if (this.rowCount >= this.maxValue) return
    this.rowsTarget.appendChild(this.templateTarget.content.cloneNode(true))
    this.refreshButtons()
  }

  remove(event) {
    if (this.rowCount <= this.minValue) return
    event.currentTarget.closest("tr").remove()
    this.refreshButtons()
  }

  get rowCount() {
    return this.rowsTarget.querySelectorAll("tr").length
  }

  refreshButtons() {
    this.addButtonTarget.disabled = this.rowCount >= this.maxValue
    this.removeButtonTargets.forEach((btn) => { btn.disabled = this.rowCount <= this.minValue })
  }
}
