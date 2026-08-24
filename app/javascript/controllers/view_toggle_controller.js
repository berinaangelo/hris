import { Controller } from "@hotwired/stimulus"

// Card/list view toggle on Company Reviews — see
// kos/decisions/ui/company-reviews-roster-filterable-grid-list.md.
// First Stimulus controller in this app beyond the hello_controller
// placeholder; kept intentionally minimal (two targets, two actions).
// listBtn/cardsBtn are optional — People Directory's icon-button toggle
// uses them for an is-active pressed state, Company Reviews' plain
// text-button toggle doesn't declare them and nothing breaks.
export default class extends Controller {
  static targets = ["list", "cards", "listBtn", "cardsBtn"]

  showList() {
    this.listTarget.hidden = false
    this.cardsTarget.hidden = true
    if (this.hasListBtnTarget) this.listBtnTarget.classList.add("is-active")
    if (this.hasCardsBtnTarget) this.cardsBtnTarget.classList.remove("is-active")
  }

  showCards() {
    this.listTarget.hidden = true
    this.cardsTarget.hidden = false
    if (this.hasCardsBtnTarget) this.cardsBtnTarget.classList.add("is-active")
    if (this.hasListBtnTarget) this.listBtnTarget.classList.remove("is-active")
  }
}
