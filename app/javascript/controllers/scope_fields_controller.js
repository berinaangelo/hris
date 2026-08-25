import { Controller } from "@hotwired/stimulus"

// "Start new cycle" modal (Company Reviews) — shows the field group(s)
// matching the selected Scope instantly, no page reload, replacing the
// old GET-scope-select-then-reload flow. See
// kos/decisions/ui/company-reviews-roster-filterable-grid-list.md.
// Same show/hide-by-target shape as view_toggle_controller.js; plural
// targets since the individual scope's fields span two separate
// containers (the employee select and the KPI section below it).
export default class extends Controller {
  static targets = ["individualFields", "departmentFields", "companyFields"]

  toggle(event) {
    const scope = event.target.value
    this.individualFieldsTargets.forEach((el) => { el.hidden = scope !== "individual" })
    this.departmentFieldsTargets.forEach((el) => { el.hidden = scope !== "department" })
    this.companyFieldsTargets.forEach((el) => { el.hidden = scope !== "company" })
  }
}
