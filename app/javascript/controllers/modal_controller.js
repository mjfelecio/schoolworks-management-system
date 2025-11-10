import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="modal"
export default class extends Controller {
  connect() {
    console.log("Connected")
    if (this.element.tagName.toLowerCase() === "dialog") {
      this.element.showModal()
    } else {
      // If the modal container wraps the dialog
      const dialog = this.element.querySelector("dialog")
      if (dialog) dialog.showModal()
    }
  }
}


