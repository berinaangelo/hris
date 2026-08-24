import { Controller } from "@hotwired/stimulus"

// Generic display<->form pencil toggle. First use: Employee Detail's
// Personal & Contact / Org Position sections and Employee Benefits'
// repeatable plan cards — both call for the identical mechanic, see
// kos/decisions/ui/employee-detail-inline-edit-with-reserved-tabs.md
// and kos/decisions/ui/employee-benefits-repeatable-plan-cards.md.
// Plural display/form targets (not singular) so one controller instance
// can also drive a section-level "+ Add" trigger — e.g. Employee
// Benefits' section header button and its empty-state both hide
// together when the blank "add a plan" form opens.
export default class extends Controller {
  static targets = ["display", "form"]
  static values = { open: Boolean }

  // Lets the server force this section into edit mode on connect — a
  // failed submit re-renders the page with the form still open instead
  // of silently reverting to read mode with the errors hidden. Same
  // trick as modal_controller.js's openValue.
  connect() {
    if (this.openValue) this.edit()
  }

  edit() {
    this.displayTargets.forEach((el) => { el.hidden = true })
    this.formTargets.forEach((el) => { el.hidden = false })
  }

  cancel() {
    this.displayTargets.forEach((el) => { el.hidden = false })
    this.formTargets.forEach((el) => { el.hidden = true })
  }
}
