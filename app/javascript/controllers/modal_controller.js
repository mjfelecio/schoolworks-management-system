import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="modal"
export default class extends Controller {
  static targets = ["dialog"]

  connect() {
    // Ensure we have a dialog element
    this.dialog = this.dialogTarget || (this.element.tagName.toLowerCase() === "dialog" 
      ? this.element 
      : this.element.querySelector("dialog"))

    if (!this.dialog) {
      console.warn("No <dialog> element found")
      return
    }

    this.openModal()
  }

  openModal() {
    if (!this.dialog) return
    if (typeof this.dialog.showModal === "function") {
      this.dialog.showModal()
    } else {
      console.warn("Element is not a <dialog> or does not support showModal()")
    }
  }

  closeModal() {
    if (!this.dialog) return
    if (typeof this.dialog.close === "function") {
      this.dialog.close()
    } else {
      console.warn("Element is not a <dialog> or does not support close()")
    }
  }
}
