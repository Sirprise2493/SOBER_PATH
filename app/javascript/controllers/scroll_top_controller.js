import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    top: { type: Number, default: 0 },
    delay: { type: Number, default: 0}
  }

  go(event) {
    event.preventDefault()

    const url = event.currentTarget.href
    if (!url) return

    window.scrollTo({
      top: this.topValue,
      behavior: "smooth"
    })

    setTimeout(() => {
      window.location.href = url
    }, this.delayValue)
  }
}
