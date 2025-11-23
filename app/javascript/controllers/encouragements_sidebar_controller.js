import { Controller } from "@hotwired/stimulus"

// data-controller="encouragements-sidebar"
export default class extends Controller {
  static targets = ["member", "search", "message", "messagesWrapper"]

  connect() {
    this.selectedSenderId = null
  }

  filterMembers() {
    const term = this.searchTarget.value.toLowerCase().trim()

    this.memberTargets.forEach((el) => {
      const name = (el.dataset.name || "").toLowerCase()
      const preview = (el.dataset.preview || "").toLowerCase()
      const match = name.includes(term) || preview.includes(term)
      el.classList.toggle("is-hidden", !match)
    })
  }

  filterMessages(event) {
    const senderId = event.currentTarget.dataset.senderId
    this.selectedSenderId = senderId

    let count = 0

    this.messageTargets.forEach((el) => {
      const matches = el.dataset.senderId === senderId
      el.classList.toggle("is-hidden", !matches)

      if (matches) {
        count += 1
      }
    })

    // Nur die letzten 10 anzeigen
    const visibleMessages = this.messageTargets.filter(
      (el) => !el.classList.contains("is-hidden")
    )

    visibleMessages.forEach((el, index) => {
      el.classList.toggle("is-hidden", index >= 10)
    })

    // aktive Markierung in der Sidebar
    this.memberTargets.forEach((el) => {
      el.classList.toggle(
        "is-active",
        el.dataset.senderId === senderId
      )
    })
  }

  showAll() {
    this.selectedSenderId = null
    this.searchTarget.value = ""

    this.memberTargets.forEach((el) => {
      el.classList.remove("is-hidden", "is-active")
    })

    // Alle Nachrichten anzeigen (oder z.B. global auf 50 limitieren)
    this.messageTargets.forEach((el, index) => {
      el.classList.toggle("is-hidden", index >= 50) // optionales globales Limit
    })
  }
}
