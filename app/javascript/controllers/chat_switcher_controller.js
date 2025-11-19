import { Controller } from "@hotwired/stimulus"

// handles switching between AI chat and Chats on the left sidebar
export default class extends Controller {
  static targets = ["aiSection", "communitySection", "tab", "communityList", "sidebar", "connections"]

  showAi(event) {
    event.preventDefault()
    this._activateTab(event.currentTarget)

    this.aiSectionTarget.classList.remove("d-none")
    this.communitySectionTarget.classList.add("d-none")

    if (this.hasCommunityListTarget) {
      this.communityListTarget.classList.add("d-none")
    }
    if (this.hasSidebarTarget) {
      this.sidebarTarget.classList.add("chat-sidebar--compact")
    }
    if (this.hasConnectionsTarget) {
      this.connectionsTarget.classList.add("d-none")
    }
  }

  showCommunity(event) {
    event.preventDefault()
    this._activateTab(event.currentTarget)

    this.communitySectionTarget.classList.remove("d-none")
    this.aiSectionTarget.classList.add("d-none")

    if (this.hasCommunityListTarget) {
      this.communityListTarget.classList.remove("d-none")
    }
    if (this.hasSidebarTarget) {
      this.sidebarTarget.classList.remove("chat-sidebar--compact")
    }
    if (this.hasConnectionsTarget) {
      this.connectionsTarget.classList.remove("d-none")
    }

    // jump to latest message
    const feed = document.getElementById("user_chat_messages")
    if (feed) {
      feed.scrollTop = feed.scrollHeight
    }
  }

  _activateTab(activeTab) {
    this.tabTargets.forEach((tab) => {
      tab.classList.toggle("chat-sidebar__item--active", tab === activeTab)
    })
  }
}
