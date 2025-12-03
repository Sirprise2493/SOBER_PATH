// app/javascript/controllers/auth_modal_controller.js
import { Controller } from "@hotwired/stimulus"

// Connect to data-controller="auth-modal"
export default class extends Controller {
  connect() {
    console.log("auth-modal connected")
    this.modal = null
    this.loginPanel = null
    this.signupPanel = null
  }

  openLogin(event) {
    console.log("open login clicked")
    event.preventDefault()
    this.ensureModal()
    this.showPanel("login")
  }

  openSignup(event) {
    console.log("open signup clicked")
    event.preventDefault()
    this.ensureModal()
    this.showPanel("signup")
  }

  ensureModal() {
    // Modal schon erzeugt? Dann wiederverwenden.
    if (this.modal) return

    const template = document.getElementById("auth-modal-template")
    if (!template) {
      console.warn("auth-modal: #auth-modal-template not found")
      return
    }

    // Template-Inhalt klonen und an <body> anhängen
    const fragment = template.content.cloneNode(true)
    const backdrop = fragment.querySelector(".auth-modal-backdrop")

    if (!backdrop) {
      console.warn("auth-modal: .auth-modal-backdrop not found in template")
      return
    }

    document.body.appendChild(fragment)
    this.modal = backdrop

    // Panels cachen
    this.loginPanel = this.modal.querySelector('[data-auth-modal-target="loginPanel"]')
    this.signupPanel = this.modal.querySelector('[data-auth-modal-target="signupPanel"]')

    // Close-Button
    const closeBtn = this.modal.querySelector(".auth-modal-close")
    if (closeBtn) {
      closeBtn.addEventListener("click", () => this.close())
    }

    // Klick auf Hintergrund schließt das Modal
    this.modal.addEventListener("click", (event) => {
      if (event.target === this.modal) this.close()
    })
  }

  showPanel(kind) {
    if (!this.modal) return

    // Modal sichtbar machen
    this.modal.classList.add("auth-modal-backdrop--visible")

    // Login/Signup-Panels umschalten
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
