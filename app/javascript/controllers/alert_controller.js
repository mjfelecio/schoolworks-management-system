import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="alert"
export default class extends Controller {
  static targets = ["container"]
  static values = { type: String }

  connect() {
    // Animate in
    setTimeout(() => {
      this.containerTarget.classList.remove("opacity-0", "translate-x-full")
      this.containerTarget.classList.add("opacity-100", "translate-x-0")
    }, 10)

    // Auto-dismiss after 5 seconds
    this.timeout = setTimeout(() => {
      this.close()
    }, 5000)
  }

  disconnect() {
    if (this.timeout) {
      clearTimeout(this.timeout)
    }
  }

  close() {
    // Animate out
    this.containerTarget.classList.remove("opacity-100", "translate-x-0")
    this.containerTarget.classList.add("opacity-0", "translate-x-full")
    
    // Remove element after animation
    setTimeout(() => {
      this.element.remove()
    }, 300)
  }
}