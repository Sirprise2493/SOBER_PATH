import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="countdown"
export default class extends Controller {
  static targets = ["output"]
  static values = { targetTime: String }

  connect() {
    this.endTime = new Date(this.targetTimeValue)
    this.update()
    this.timer = setInterval(() => this.update(), 1000)
  }

  disconnect() {
    if (this.timer) clearInterval(this.timer)
  }

  update() {
    const now = new Date()
    let diffSeconds = Math.floor((this.endTime - now) / 1000)

    if (diffSeconds <= 0) {
      this.outputTarget.textContent = "Reached 🎉"
      clearInterval(this.timer)
      return
    }

    const secondsPerMinute = 60
    const secondsPerHour   = 60 * secondsPerMinute
    const secondsPerDay    = 24 * secondsPerHour
    const secondsPerMonth  = 30 * secondsPerDay
    const secondsPerYear   = 365 * secondsPerDay

    let years  = Math.floor(diffSeconds / secondsPerYear)
    diffSeconds -= years * secondsPerYear

    let months = Math.floor(diffSeconds / secondsPerMonth)
    diffSeconds -= months * secondsPerMonth

    let days   = Math.floor(diffSeconds / secondsPerDay)
    diffSeconds -= days * secondsPerDay

    let hours   = Math.floor(diffSeconds / secondsPerHour)
    diffSeconds -= hours * secondsPerHour

    let minutes = Math.floor(diffSeconds / secondsPerMinute)
    let seconds = diffSeconds - minutes * secondsPerMinute

    // Which time elements will be shown
    let parts = []

    if (years > 0) {
      // y / m / d / h / m / s
      parts.push(`${this.pad(years)}y`)
      parts.push(`${this.pad(months)}m`)
      parts.push(`${this.pad(days)}d`)
      parts.push(`${this.pad(hours)}h`)
      parts.push(`${this.pad(minutes)}m`)
      parts.push(`${this.pad(seconds)}s`)
    } else if (months > 0) {
      // m / d / h / m / s
      parts.push(`${this.pad(months)}m`)
      parts.push(`${this.pad(days)}d`)
      parts.push(`${this.pad(hours)}h`)
      parts.push(`${this.pad(minutes)}m`)
      parts.push(`${this.pad(seconds)}s`)
    } else if (days > 0) {
      // d / h / m / s
      parts.push(`${this.pad(days)}d`)
      parts.push(`${this.pad(hours)}h`)
      parts.push(`${this.pad(minutes)}m`)
      parts.push(`${this.pad(seconds)}s`)
    } else if (hours > 0) {
      // h / m / s
      parts.push(`${this.pad(hours)}h`)
      parts.push(`${this.pad(minutes)}m`)
      parts.push(`${this.pad(seconds)}s`)
    } else if (minutes > 0) {
      // m / s
      parts.push(`${this.pad(minutes)}m`)
      parts.push(`${this.pad(seconds)}s`)
    } else {
      // nur Sekunden
      parts.push(`${this.pad(seconds)}s`)
    }

    this.outputTarget.textContent = parts.join(" : ")
  }

  pad(n) {
    return String(n).padStart(2, "0")
  }
}
