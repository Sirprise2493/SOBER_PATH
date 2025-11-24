import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    const feed = document.getElementById("user_chat_messages")
    if (feed) {
      feed.classList.add("d-none")
    }

    // hide main community input bar while thread is open
    const mainForm = document.getElementById("user-chat-main-form")
    if (mainForm) {
      mainForm.classList.add("d-none")
    }

    const content = this.element.querySelector(".message-thread__content")
    if (content) {
      requestAnimationFrame(() => {
        content.scrollTop = content.scrollHeight
      })
    }
  }

  close() {
    const feed = document.getElementById("user_chat_messages")
    if (feed) {
      feed.classList.remove("d-none")
    }

    const mainForm = document.getElementById("user-chat-main-form")
    if (mainForm) {
      mainForm.classList.remove("d-none")
    }

    const frame = this.element.closest("turbo-frame")

    if (frame) {
      frame.innerHTML = ""
    } else {
      this.element.remove()
    }
  }
}