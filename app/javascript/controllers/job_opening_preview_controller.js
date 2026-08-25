import { Controller } from "@hotwired/stimulus"

// Job Opening Form's live mini-preview — mirrors title + status into
// the exact card HR will see on Job Openings, same "show the real
// result before commit" reasoning as Add Employee's
// live_preview_controller.js. Pipeline counts aren't mirrored here —
// editing title/status doesn't change candidate counts, so that part
// of the preview stays server-rendered.
export default class extends Controller {
  static targets = ["title", "status", "previewName", "previewBadge"]

  connect() {
    this.update()
  }

  update() {
    this.previewNameTarget.textContent = this.titleTarget.value.trim() || "Untitled opening"

    const checked = this.statusTargets.find((radio) => radio.checked)
    const isOpen = !checked || checked.value === "open"
    this.previewBadgeTarget.textContent = isOpen ? "Open" : "Closed"
    this.previewBadgeTarget.classList.toggle("badge-positive", isOpen)
    this.previewBadgeTarget.classList.toggle("badge-neutral", !isOpen)
  }
}
