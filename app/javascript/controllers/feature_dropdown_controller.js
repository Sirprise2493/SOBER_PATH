import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["button", "box"]

  connect() {
    this.descriptions = {
      concept: "Our mission is combining peer support, evidence-based tools, and expert guidance to empower lasting recovery.",
      studies: "Access data, clinical studies, and scientific findings about addiction, healing strategies, and recovery best-practice.",
      statistics: "Real progress, positive outcomes, and inspiring numbers from the SoberPath community."
    }
    this.currentFeature = null
    this.handleClickOutside = this.handleClickOutside.bind(this)
    document.addEventListener('click', this.handleClickOutside)
  }

  disconnect() {
    document.removeEventListener('click', this.handleClickOutside)
  }

  show(event) {
    const feature = event.currentTarget.dataset.feature

    if (this.currentFeature === feature) {
      this.closeBox()
      return
    }

    this.buttonTargets.forEach(btn => btn.classList.remove("active"))
    event.currentTarget.classList.add("active")

    this.boxTarget.innerHTML = `<div class="main-feature-desc">${this.descriptions[feature]}</div>`
    this.boxTarget.classList.add("show")
    this.currentFeature = feature
  }

  closeBox() {
    this.boxTarget.innerHTML = ""
    this.boxTarget.classList.remove("show")
    this.buttonTargets.forEach(btn => btn.classList.remove("active"))
    this.currentFeature = null
  }

  handleClickOutside(event) {
    if (
      !this.element.contains(event.target) &&
      this.boxTarget.classList.contains('show')
    ) {
      this.closeBox()
    }
  }
}
