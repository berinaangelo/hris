import { Controller } from "@hotwired/stimulus"

// Card/list view toggle on Company Reviews — see
// kos/decisions/ui/company-reviews-roster-filterable-grid-list.md.
// First Stimulus controller in this app beyond the hello_controller
// placeholder; kept intentionally minimal (two targets, two actions).
export default class extends Controller {
  static targets = ["list", "cards"]

  showList() {
    this.listTarget.hidden = false
    this.cardsTarget.hidden = true
  }

  showCards() {
    this.listTarget.hidden = true
    this.cardsTarget.hidden = false
  }
}
