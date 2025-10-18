import { Controller } from "@hotwired/stimulus"
import { post } from "@rails/request.js"

// Connects to data-controller="cookies"
export default class extends Controller {
  static values = {
    storageKey: { type: String, default: "cookies_accepted" },
    acceptUrl: { type: String, default: "/cookies/accept" },
    animate: { type: Boolean, default: true }
  }
  COOKIE_ACCEPTED = `${this.storageKeyValue}=true`

  connect() {
    const accepted = document.cookie.includes(this.COOKIE_ACCEPTED)
    if (accepted) {
      this.hideElement()
    } else {
      this.showElement()
    }
  }

  async accept(event) {
    if (event) event.preventDefault()
    const url = this.acceptUrlValue

    const response = await post(url)
    if (response.ok) {
      document.cookie = `${this.storageKeyValue}=true`
      if (this.animateValue) {
        this.element.style.transition = "transform 0.3s ease-in-out"
        this.element.style.transform = "translateY(100%)"
        setTimeout(() => {
          this.hideElement()
        }, 300)
      } else {
        this.hideElement()
      }
    } else {
      console.error("Failed to accept cookies:", response)
    }
  }

  showElement() {
    this.element.style.display = ""
    this.element.style.transform = "translateY(0)"
  }

  hideElement() {
    this.element.style.display = "none"
  }
}
