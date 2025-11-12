import { Controller } from "@hotwired/stimulus"

// Controls one meeting row: auto-compute ends_at and toggle online URL visibility.
export default class extends Controller {
  static targets = ["start", "duration", "endsPreview", "endsHidden", "onlineUrlWrap"]

  connect() {
    this.toggleOnline()    // set initial visibility
    this.recalc()          // compute initial ends_at preview if possible
  }

  toggleOnline() {
    // Find the is_online checkbox in this row
    const checkbox = this.element.querySelector("input[type='checkbox'][name*='[is_online]']")
    const show = checkbox && checkbox.checked
    if (this.hasOnlineUrlWrapTarget) {
      this.onlineUrlWrapTarget.style.display = show ? "" : "none"
    }
  }

  recalc() {
    const startStr = this.startTarget?.value
    const durStr   = this.durationTarget?.value
    if (!startStr || !durStr) return

    // Parse "HH:MM" and add minutes
    const [h, m] = startStr.split(":").map(Number)
    const startMinutes = h * 60 + m
    const duration = parseInt(durStr, 10)
    const endMinutes = (startMinutes + duration) % (24 * 60)

    const hh = String(Math.floor(endMinutes / 60)).padStart(2, "0")
    const mm = String(endMinutes % 60).padStart(2, "0")
    const endStr = `${hh}:${mm}`

    // Show preview and set hidden field (Rails TIME column accepts "HH:MM")
    if (this.hasEndsPreviewTarget) this.endsPreviewTarget.textContent = endStr
    if (this.hasEndsHiddenTarget)  this.endsHiddenTarget.value = endStr
  }
}
