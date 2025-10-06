import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "profileMenu",
    "loginMenu",
    "mobileMenu",
    "mobileOpenIcon",
    "mobileCloseIcon"
  ]

  connect() {
    this._outsideHandler = this.handleOutsideClick.bind(this)
    document.addEventListener("click", this._outsideHandler)

    this.resetMenus()

    this._pageshowHandler = (e) => { if (e.persisted) this.resetMenus() }
    window.addEventListener("pageshow", this._pageshowHandler)
  }

  disconnect() {
    document.removeEventListener("click", this._outsideHandler)
    window.removeEventListener("pageshow", this._pageshowHandler)
  }

  toggleProfileMenu(event) {
    event.stopPropagation()
    this.toggleMenu(this.profileMenuTarget)
  }

  toggleLoginMenu(event) {
    event.stopPropagation()
    this.toggleMenu(this.loginMenuTarget)
  }

  toggleMobileMenu(event) {
    event.stopPropagation()
    if (!this.hasMobileMenuTarget) return
    this.toggleMenu(this.mobileMenuTarget, { mobile: true })
    this.swapMobileIcons()
  }

  closeMobileMenu() {
    if (!this.mobileMenuTarget.classList.contains("hidden")) {
      this.hideMenu(this.mobileMenuTarget)
      this.show(this.mobileOpenIconTarget)
      this.hide(this.mobileCloseIconTarget)
    }
  }

  handleOutsideClick(event) {
    if (this.hasProfileMenuTarget &&
        !this.profileMenuTarget.contains(event.target) &&
        !event.target.closest("[data-action*='navbar#toggleProfileMenu']")) {
      this.hideMenu(this.profileMenuTarget)
    }
    if (this.hasLoginMenuTarget &&
        !this.loginMenuTarget.contains(event.target) &&
        !event.target.closest("[data-action*='navbar#toggleLoginMenu']")) {
      this.hideMenu(this.loginMenuTarget)
    }
    if (this.hasMobileMenuTarget &&
        !this.mobileMenuTarget.contains(event.target) &&
        !event.target.closest("[data-action*='navbar#toggleMobileMenu']")) {
      this.closeMobileMenu()
    }
  }

  toggleMenu(el, opts = {}) {
    if (el.classList.contains("hidden")) {
      this.showMenu(el, opts)
    } else {
      this.hideMenu(el, opts)
    }
  }

  showMenu(el, _opts = {}) {
    if (!el.classList.contains("hidden")) return
    el.classList.remove("hidden")
    el.classList.add("transform", "transition", "ease-out", "duration-200", "opacity-0", "scale-95")
    requestAnimationFrame(() => {
      el.classList.remove("opacity-0", "scale-95")
      el.classList.add("opacity-100", "scale-100")
      setTimeout(() => {
        el.classList.remove("transition", "ease-out", "duration-200")
      }, 200)
    })
  }

  hideMenu(el, _opts = {}) {
    if (el.classList.contains("hidden")) return
    el.classList.add("transform", "transition", "ease-in", "duration-75")
    el.classList.remove("opacity-0", "scale-95")
    el.classList.add("opacity-100", "scale-100")
    requestAnimationFrame(() => {
      el.classList.remove("opacity-100", "scale-100")
      el.classList.add("opacity-0", "scale-95")
      setTimeout(() => {
        el.classList.add("hidden")
        el.classList.remove("transition", "ease-in", "duration-75", "opacity-0", "scale-95")
      }, 75)
    })
  }

  swapMobileIcons() {
    if (this.mobileMenuTarget.classList.contains("hidden")) {
      this.show(this.mobileOpenIconTarget)
      this.hide(this.mobileCloseIconTarget)
    } else {
      this.hide(this.mobileOpenIconTarget)
      this.show(this.mobileCloseIconTarget)
    }
  }

  hide(el) { el.classList.add("hidden") }
  show(el) { el.classList.remove("hidden") }

  resetMenus() {
    if (this.hasProfileMenuTarget) this.forceHide(this.profileMenuTarget)
    if (this.hasLoginMenuTarget) this.forceHide(this.loginMenuTarget)
    if (this.hasMobileMenuTarget) this.forceHide(this.mobileMenuTarget)
    if (this.hasMobileOpenIconTarget) this.show(this.mobileOpenIconTarget)
    if (this.hasMobileCloseIconTarget) this.hide(this.mobileCloseIconTarget)
  }

  forceHide(el) {
    el.classList.add("hidden")
    el.classList.remove(
      "opacity-0","opacity-100",
      "scale-95","scale-100",
      "transition","ease-out","ease-in",
      "duration-200","duration-75"
    )
  }
}

