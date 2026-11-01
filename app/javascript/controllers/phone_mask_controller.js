import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input"]

  connect() {
    this.format()
  }

  format() {
    const digits = this.inputTarget.value.replace(/\D/g, "").slice(0, 11)
    this.inputTarget.value = this.mask(digits)
  }

  unmask() {
    this.inputTarget.value = this.inputTarget.value.replace(/\D/g, "")
  }

  mask(digits) {
    if (digits.length === 0) return ""
    if (digits.length === 1) return `(${digits}`

    const areaCode = digits.slice(0, 2)
    const number = digits.slice(2)
    const separator = number.length > 8 ? 5 : 4
    const firstPart = number.slice(0, separator)
    const secondPart = number.slice(separator)

    return `(${areaCode}) ${firstPart}${secondPart ? `-${secondPart}` : ""}`
  }
}
