import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["filter", "item"]

  filter() {
    const query = this.filterTarget.value.trim().toLowerCase()

    this.itemTargets.forEach((el) => {
      const name = el.dataset.username.toLowerCase()
      const match = query === "" || name.includes(query)
      el.classList.toggle("d-none", !match)
    })
  }
}
