import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["fullList", "button"]

  toggle() {
    this.fullListTarget.classList.toggle("d-none")

    if (this.fullListTarget.classList.contains("d-none")) {
      this.buttonTarget.innerText = `Show all ${this.buttonTarget.dataset.total} friends`
    } else {
      this.buttonTarget.innerText = "Show less"
    }
  }
}
