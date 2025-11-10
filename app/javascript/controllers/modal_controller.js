import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="modal"
export default class extends Controller {
  static targets = ["dialog"]

  connect() {
    const dialog = this.dialogTarget || this.element.tagName.toLowerCase() === "dialog" 
      ? this.element 
      : this.element.querySelector("dialog")

    if (!dialog) return

    if (typeof dialog.showModal === "function") {
      dialog.showModal()
    } else {
      console.warn("Element is not a <dialog> or does not support showModal()")
    }
  }
}
