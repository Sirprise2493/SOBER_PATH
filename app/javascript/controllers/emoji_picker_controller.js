import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "panel"]

  toggle() {
    this.panelTarget.classList.toggle("d-none")
  }

  add(event) {
    const emoji = event.currentTarget.dataset.emoji

    const input = this.inputTarget
    const start = input.selectionStart || input.value.length
    const end   = input.selectionEnd || input.value.length

    const before = input.value.slice(0, start)
    const after  = input.value.slice(end)

    input.value = before + emoji + after

    const newPos = start + emoji.length
    input.setSelectionRange(newPos, newPos)
    input.focus()
  }
}
