// app/javascript/controllers/feature_dropdown_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["button", "box"]
  currentPanel = null

  show(event) {
    const panelName = event.currentTarget.dataset.panel
    this.activate(panelName)
  }

  activate(panelName) {
    const isSamePanel = this.currentPanel === panelName
    const isOpen = this.boxTarget.classList.contains("show")

    // Same button & box open -> close
    if (isSamePanel && isOpen) {
      this.closeBox()
      return
    }

    // Otherwise open with new content
    this.openBox(panelName)
  }

  openBox(panelName) {
    this.currentPanel = panelName

    // Update buttons
    this.buttonTargets.forEach((button) => {
      const active = button.dataset.panel === panelName
      button.classList.toggle("feature-btn--active", active)
      button.setAttribute("aria-pressed", active ? "true" : "false")
    })

    // Load content from hidden panel
    const source = this.element.querySelector(
      `[data-panel='${panelName}-content']`
    )

    if (source) {
      this.boxTarget.innerHTML = source.innerHTML
      this.boxTarget.classList.add("show")

      // Manually scroll page so the box is clearly visible
      const rect = this.boxTarget.getBoundingClientRect()
      const absoluteTop = rect.top + window.scrollY

      window.scrollTo({
        top: absoluteTop - 120, // adjust 120 to where you want the box to sit
        behavior: "smooth"
      })
    }
  }

  closeBox() {
    this.currentPanel = null

    this.buttonTargets.forEach((button) => {
      button.classList.remove("feature-btn--active")
      button.setAttribute("aria-pressed", "false")
    })

    this.boxTarget.classList.remove("show")
    this.boxTarget.innerHTML = ""
  }
}
