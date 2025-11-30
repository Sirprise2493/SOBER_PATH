import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    top: { type: Number, default: 0 },
    delay: { type: Number, default: 0 }
  }

  static targets = ["calendarPanel", "calendarButton"]

  connect() {
    this.isCalendarOpen = false

    if (this.hasCalendarPanelTarget) {
      this.calendarPanelTarget.style.maxHeight = 0
      this.calendarPanelTarget.classList.remove("journal-calendar-panel--open")
    }

    if (this.hasCalendarButtonTarget) {
      this.calendarButtonTarget.setAttribute("aria-expanded", "false")
    }
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

  toggleCalendar() {
    if (!this.hasCalendarPanelTarget) return
    this.isCalendarOpen ? this.closeCalendar() : this.openCalendar()
  }

  openCalendar() {
    const panel = this.calendarPanelTarget
    panel.style.maxHeight = panel.scrollHeight + "px"
    panel.classList.add("journal-calendar-panel--open")

    if (this.hasCalendarButtonTarget) {
      this.calendarButtonTarget.setAttribute("aria-expanded", "true")
    }

    this.isCalendarOpen = true
  }

  closeCalendar() {
    const panel = this.calendarPanelTarget
    panel.style.maxHeight = 0
    panel.classList.remove("journal-calendar-panel--open")

    if (this.hasCalendarButtonTarget) {
      this.calendarButtonTarget.setAttribute("aria-expanded", "false")
    }

    this.isCalendarOpen = false
  }
}
