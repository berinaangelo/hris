import { Controller } from "@hotwired/stimulus"

// Org Chart's per-manager-card collapse/expand — the whole card is its
// own control, no separate chevron button to learn. All branches open
// by default — see kos/decisions/ui/org-chart-classic-top-down-tree.md.
export default class extends Controller {
  static targets = ["children", "chevron"]

  toggle() {
    this.childrenTarget.hidden = !this.childrenTarget.hidden
    this.chevronTarget.classList.toggle("is-collapsed", this.childrenTarget.hidden)
  }
}
