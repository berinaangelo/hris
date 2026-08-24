import { Controller } from "@hotwired/stimulus"

// Generic named-tab switcher. First use: Employee Detail's top-level
// Profile / Loan Ledger / Benefits tabs — see
// kos/decisions/ui/employee-detail-inline-edit-with-reserved-tabs.md.
// Server-rendered markup marks the initial active tab/panel (via
// is-active / hidden); this only handles clicks.
export default class extends Controller {
  static targets = ["tab", "panel"]

  select(event) {
    const name = event.params.name
    this.tabTargets.forEach((tab) => tab.classList.toggle("is-active", tab === event.currentTarget))
    this.panelTargets.forEach((panel) => { panel.hidden = panel.dataset.tabsPanel !== name })
  }
}
