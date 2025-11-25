import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="venue-toggle"
export default class extends Controller {
  static targets = ["body", "form"]
  static values = { open: Boolean }

  connect() {
    if (this.hasOpenValue && this.openValue) {
      this.show()
    }
  }

  toggle(event) {
    event.preventDefault()
    if (this.bodyTarget.classList.contains("d-none")) {
      this.show()
    } else {
      this.hide()
    }
  }

  show() {
    this.bodyTarget.classList.remove("d-none")
  }

  hide() {
    this.bodyTarget.classList.add("d-none")
  }


  handleSubmitEnd(event) {
    if (event.detail.success) {
      this.hide()
    }
  }
}
