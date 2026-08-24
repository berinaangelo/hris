import { Controller } from "@hotwired/stimulus"

// Add Employee's live "Directory preview" card — mirrors the form's
// own inputs into a read-only preview of the exact card this person
// will get in People Directory. Nothing is persisted; purely
// client-side feedback. See
// kos/decisions/ui/add-employee-split-live-preview.md.
export default class extends Controller {
  static targets = [
    "firstName", "lastName", "jobTitle", "department", "manager", "startDate", "employmentType",
    "previewAvatar", "previewName", "previewRole", "previewDept", "previewYear",
    "previewManager", "previewStartDate", "previewType"
  ]

  connect() {
    this.update()
  }

  update() {
    const first = this.firstNameTarget.value.trim()
    const last = this.lastNameTarget.value.trim()
    this.previewAvatarTarget.textContent = (first.charAt(0) + last.charAt(0)).toUpperCase() || "—"
    this.previewNameTarget.textContent = [ first, last ].filter(Boolean).join(" ") || "New employee"
    this.previewRoleTarget.textContent = this.jobTitleTarget.value || "—"
    this.previewDeptTarget.textContent = this.departmentTarget.value || "—"

    const managerOption = this.managerTarget.options[this.managerTarget.selectedIndex]
    this.previewManagerTarget.textContent = managerOption && managerOption.value ? managerOption.text : "No manager"

    const startDateValue = this.startDateTarget.value
    if (startDateValue) {
      const date = new Date(`${startDateValue}T00:00:00`)
      this.previewYearTarget.textContent = date.getFullYear()
      this.previewStartDateTarget.textContent = date.toLocaleDateString("en-US", { month: "short", day: "numeric", year: "numeric" })
    } else {
      this.previewYearTarget.textContent = "—"
      this.previewStartDateTarget.textContent = "—"
    }

    const typeOption = this.employmentTypeTarget.options[this.employmentTypeTarget.selectedIndex]
    this.previewTypeTarget.textContent = typeOption ? typeOption.text : "—"
  }
}
