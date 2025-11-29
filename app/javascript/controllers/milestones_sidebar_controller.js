import { Controller } from "@hotwired/stimulus"

// Steuert die Sidebar-Tabs auf der Milestones-Seite
export default class extends Controller {
  static targets = ["button", "panel"]

  connect() {
    // Falls kein Button als active markiert ist, ersten aktivieren
    if (!this.buttonTargets.some((btn) =>
      btn.classList.contains("milestones-sidebar__button--active")
    )) {
      const first = this.buttonTargets[0]
      if (first) this.activate(first.dataset.panel)
    }
  }

  show(event) {
    const panelName = event.currentTarget.dataset.panel
    this.activate(panelName)
  }

  activate(panelName) {
    // Buttons
    this.buttonTargets.forEach((button) => {
      const isActive = button.dataset.panel === panelName
      button.classList.toggle(
        "milestones-sidebar__button--active",
        isActive
      )
      button.setAttribute("aria-pressed", isActive ? "true" : "false")
    })

    // Panels
    this.panelTargets.forEach((panel) => {
      const isActive = panel.dataset.panel === panelName
      panel.classList.toggle(
        "milestones-content__panel--active",
        isActive
      )
      panel.hidden = !isActive
    })
  }
}
