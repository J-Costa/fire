import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "advanced",
    "advancedPanel",
    "advancedToggle",
    "description1",
    "description2",
    "guided",
    "json",
    "subjects",
    "subjectTemplate",
    "total",
    "workload"
  ]

  connect() {
    this.programData = this.parseJson(this.jsonTarget.value) || {}
    this.updateTotal()
    this.syncAdvanced()
  }

  submit() {
    if (this.advancedToggleTarget.checked) {
      this.jsonTarget.value = this.advancedTarget.value
      return
    }

    this.jsonTarget.value = JSON.stringify(this.guidedData())
  }

  toggleMode() {
    if (this.advancedToggleTarget.checked) {
      this.programData = this.guidedData()
      this.syncAdvanced()
      this.guidedTarget.classList.add("hidden")
      this.advancedPanelTarget.classList.remove("hidden")
      return
    }

    const data = this.parseJson(this.advancedTarget.value)
    if (data) {
      this.programData = data
      this.renderGuided(data)
    }
    this.guidedTarget.classList.remove("hidden")
    this.advancedPanelTarget.classList.add("hidden")
  }

  addSubject() {
    const row = document.createElement("div")
    row.className = "grid grid-cols-[minmax(0,1fr)_8rem_auto] items-end gap-3"
    row.dataset.programEditorSubject = ""
    row.innerHTML = `
      <div>
        <label class="block text-xs font-medium text-gray-600">Matéria</label>
        <input type="text" class="mt-1 block w-full rounded-md border-0 px-3 py-2 text-sm text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 focus:ring-2 focus:ring-inset focus:ring-red-600" data-subject-name>
      </div>
      <div>
        <label class="block text-xs font-medium text-gray-600">Horas</label>
        <input type="number" min="0" class="mt-1 block w-full rounded-md border-0 px-3 py-2 text-sm text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 focus:ring-2 focus:ring-inset focus:ring-red-600" data-subject-hours data-action="input->program-editor#updateTotal">
      </div>
      <button type="button" class="mb-0.5 rounded-md px-2 py-2 text-sm font-semibold text-gray-500 hover:bg-gray-100 hover:text-red-600" data-action="program-editor#removeSubject" title="Remover matéria" aria-label="Remover matéria">&times;</button>
    `
    this.subjectsTarget.appendChild(row)
  }

  removeSubject(event) {
    const rows = this.subjectsTarget.querySelectorAll("[data-program-editor-subject]")
    if (rows.length === 1) {
      rows[0].querySelector("[data-subject-name]").value = ""
      rows[0].querySelector("[data-subject-hours]").value = ""
    } else {
      event.currentTarget.closest("[data-program-editor-subject]").remove()
    }
    this.updateTotal()
  }

  updateTotal() {
    const total = [...this.subjectsTarget.querySelectorAll("[data-subject-hours]")]
      .reduce((sum, input) => sum + (Number(input.value) || 0), 0)
    this.totalTarget.textContent = total
  }

  calculateWorkload() {
    this.workloadTarget.value = this.totalTarget.textContent
  }

  guidedData() {
    const data = { ...this.programData }
    data.workload_hours = Number(this.workloadTarget.value) || 0
    data.subjects = [...this.subjectsTarget.querySelectorAll("[data-program-editor-subject]")]
      .map((row) => {
        const name = row.querySelector("[data-subject-name]").value.trim()
        const hours = Number(row.querySelector("[data-subject-hours]").value) || 0
        return name ? { [name]: hours } : null
      })
      .filter(Boolean)
    data.descriptions = [
      this.description1Target.value.trim() ? { "1": this.description1Target.value.trim() } : null,
      this.description2Target.value.trim() ? { "2": this.description2Target.value.trim() } : null
    ].filter(Boolean)
    return data
  }

  syncAdvanced() {
    this.advancedTarget.value = JSON.stringify(this.programData, null, 2)
  }

  renderGuided(data) {
    const subjects = Array.isArray(data.subjects) ? data.subjects : []
    this.subjectsTarget.innerHTML = ""
    subjects.forEach((subject) => {
      const [name, hours] = Object.entries(subject || {})[0] || []
      this.addSubject()
      const row = this.subjectsTarget.lastElementChild
      row.querySelector("[data-subject-name]").value = name || ""
      row.querySelector("[data-subject-hours]").value = hours || ""
    })
    if (subjects.length === 0) this.addSubject()

    this.workloadTarget.value = data.workload_hours || ""
    this.description1Target.value = this.descriptionValue(data, "1")
    this.description2Target.value = this.descriptionValue(data, "2")
    this.updateTotal()
  }

  descriptionValue(data, number) {
    const description = (Array.isArray(data.descriptions) ? data.descriptions : [])
      .find((item) => item && Object.prototype.hasOwnProperty.call(item, number))
    return description ? description[number] : ""
  }

  parseJson(value) {
    try {
      return JSON.parse(value)
    } catch (error) {
      return null
    }
  }
}
