import { Controller } from "@hotwired/stimulus"

// Connect to data-controller="auth-modal"
export default class extends Controller {
  connect() {
    this.modal = null
    this.loginPanel = null
    this.signupPanel = null
  }

  openLogin(event) {
    event.preventDefault()
    this.ensureModal()
    this.showPanel("login")
  }

  openSignup(event) {
    event.preventDefault()
    this.ensureModal()
    this.showPanel("signup")
  }

  ensureModal() {
    if (this.modal) return

    const template = document.getElementById("auth-modal-template")
    if (!template) return

    // Clone the template content and append to body
    const fragment = template.content.cloneNode(true)
    const backdrop = fragment.querySelector(".auth-modal-backdrop")

    document.body.appendChild(fragment)
    this.modal = backdrop

    // Cache panels
    this.loginPanel = this.modal.querySelector('[data-auth-modal-target="loginPanel"]')
    this.signupPanel = this.modal.querySelector('[data-auth-modal-target="signupPanel"]')

    // Close button
    const closeBtn = this.modal.querySelector(".auth-modal-close")
    if (closeBtn) {
      closeBtn.addEventListener("click", () => this.close())
    }

    // Click outside (backdrop)
    this.modal.addEventListener("click", (event) => {
      if (event.target === this.modal) this.close()
    })
  }

  showPanel(kind) {
    if (!this.modal) return

    this.modal.classList.add("auth-modal-backdrop--visible")

    if (this.loginPanel) {
      this.loginPanel.classList.toggle("auth-panel--active", kind === "login")
    }
    if (this.signupPanel) {
      this.signupPanel.classList.toggle("auth-panel--active", kind === "signup")
    }
  }

  close() {
    if (!this.modal) return
    this.modal.classList.remove("auth-modal-backdrop--visible")
  }
}
