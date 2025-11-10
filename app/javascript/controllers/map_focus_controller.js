import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { lat: Number, lng: Number }

  go() {
    const detail = { lat: Number(this.latValue), lng: Number(this.lngValue) }
    window.dispatchEvent(new CustomEvent("map:focus", { detail }))
  }
}
