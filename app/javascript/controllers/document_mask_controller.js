import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input"]

  connect() {
    this.format()
  }

  format() {
    const digits = this.inputTarget.value.replace(/\D/g, "").slice(0, 14)
    this.inputTarget.value = digits.length <= 11 ? this.maskCpf(digits) : this.maskCnpj(digits)
  }

  unmask() {
    this.inputTarget.value = this.inputTarget.value.replace(/\D/g, "")
  }

  maskCpf(digits) {
    return digits
      .replace(/(\d{3})(\d)/, "$1.$2")
      .replace(/(\d{3})(\d)/, "$1.$2")
      .replace(/(\d{3})(\d{1,2})$/, "$1-$2")
  }

  maskCnpj(digits) {
    return digits
      .replace(/(\d{2})(\d)/, "$1.$2")
      .replace(/(\d{3})(\d)/, "$1.$2")
      .replace(/(\d{3})(\d)/, "$1/$2")
      .replace(/(\d{4})(\d{1,2})$/, "$1-$2")
  }
}
