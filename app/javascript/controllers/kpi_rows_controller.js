import { Controller } from "@hotwired/stimulus"

// Dynamic 3-5 KPI row add/remove for the Team Reviews open-cycle and
// attach-KPIs forms. Client-side min/max are UX guardrails only — the
// real gate is ReviewCycles::CreateKpiEntries' own count check.
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
