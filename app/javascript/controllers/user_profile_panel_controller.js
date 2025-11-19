import { Controller } from "@hotwired/stimulus"

// handles closing the user profile panel inside the chat
export default class extends Controller {
  close() {
    const frame = this.element.closest("turbo-frame")

    if (frame) {
      frame.innerHTML = ""
    } else {
      this.element.remove()
    }
  }
}
