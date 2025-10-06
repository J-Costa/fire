import { Controller } from "@hotwired/stimulus"

const DEFAULT_INTERVAL = 5000

export default class extends Controller {
  static targets = ["slide", "indicator"]
  static values = { interval: { type: Number, default: DEFAULT_INTERVAL } }

  connect() {
    this.index = 0
    this.total = this.slideTargets.length
    this.start()
  }

  disconnect() { this.stop() }

  start() {
    this.stop()
    if (this.total > 1) {
      this.timer = setInterval(() => this.next(), this.intervalValue)
    }
  }

  stop() {
    if (this.timer) {
      clearInterval(this.timer)
      this.timer = null
    }
  }

  next() {
    this.show((this.index + 1) % this.total)
  }

  prev() {
    this.show((this.index - 1 + this.total) % this.total)
  }

  goTo(e) {
    const i = Number(e.params.index)
    if (!isNaN(i)) this.show(i)
  }

  show(newIndex) {
    if (newIndex === this.index) return
    const currentEl = this.slideTargets[this.index]
    const nextEl = this.slideTargets[newIndex]

    currentEl.classList.add("opacity-0", "scale-95", "pointer-events-none")
    currentEl.classList.remove("opacity-100", "scale-100")

    nextEl.classList.remove("opacity-0", "scale-95", "pointer-events-none", "hidden")
    nextEl.classList.add("opacity-100", "scale-100")

    this.updateIndicators(this.index, newIndex)
    this.index = newIndex
  }

  updateIndicators(oldIndex, newIndex) {
    if (!this.hasIndicatorTarget) return
    const oldI = this.indicatorTargets[oldIndex]
    const newI = this.indicatorTargets[newIndex]
    if (oldI) { oldI.classList.remove("bg-red-500"); oldI.classList.add("bg-white") }
    if (newI) { newI.classList.remove("bg-white"); newI.classList.add("bg-red-500") }
  }
}
