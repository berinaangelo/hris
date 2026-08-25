import { Controller } from "@hotwired/stimulus"

// Generic "copy to clipboard" button — first use: Job Openings/Job
// Opening Detail's "Copy apply link" chip. Kept deliberately minimal
// (one value, one action) so any future copy-a-value affordance can
// reuse it rather than growing a bespoke one.
export default class extends Controller {
  static values = { text: String }

  async copy(event) {
    const button = event.currentTarget
    const original = button.title

    try {
      await navigator.clipboard.writeText(this.textValue)
      button.title = "Copied!"
    } catch {
      button.title = "Couldn't copy — copy manually"
    }

    setTimeout(() => { button.title = original }, 1500)
  }
}
