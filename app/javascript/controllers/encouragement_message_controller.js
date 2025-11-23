import { Controller } from "@hotwired/stimulus"

// data-controller="encouragement-message"
export default class extends Controller {
  static targets = ["text"]
  static values = { fullText: String }

  connect() {
    this.expanded = false
  }

  toggle(event) {
    event.preventDefault()
    this.expanded = !this.expanded

    if (this.expanded) {
      this.textTarget.textContent = this.fullTextValue
      event.currentTarget.textContent = "Weniger anzeigen"
    } else {
      this.textTarget.textContent = this.truncate(this.fullTextValue, 60)
      event.currentTarget.textContent = "Mehr anzeigen"
    }
  }

  truncate(str, length) {
    if (!str) return ""
    if (str.length <= length) return str
    return str.slice(0, length - 1) + "…"
  }
}
