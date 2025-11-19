import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="sobriety-tray"
export default class extends Controller {
  static targets = ["overlay", "title", "date", "description"]

  showCard(event) {
    const coin = event.currentTarget

    const name = coin.dataset.sobrietyTrayName
    const description = coin.dataset.sobrietyTrayDescription
    const reachedAt = coin.dataset.sobrietyTrayReachedAt

    if (name) {
      this.titleTarget.textContent = name
    }

    if (description) {
      this.descriptionTarget.textContent = description
    }

    if (reachedAt) {
      this.dateTarget.textContent = `You received this coin on ${reachedAt}.`
    } else {
      this.dateTarget.textContent = ""
    }

    this.overlayTarget.classList.add("is-visible")
  }

  hideCard() {
    this.overlayTarget.classList.remove("is-visible")
  }

}
