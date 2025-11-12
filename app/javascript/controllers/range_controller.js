import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["label"]
  update(e) {
    const v = parseFloat(e.currentTarget.value)
    this.labelTarget.textContent = v.toFixed(1)
  }
}
