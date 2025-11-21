import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="search-form"
export default class extends Controller {
  static targets = ["input", "submit"]
  
  // Debounce timer for search input
  timeout = null
  
  // Submit form when user types (with debounce)
  submit() {
    clearTimeout(this.timeout)
    
    this.timeout = setTimeout(() => {
      // Hide submit button during auto-submit
      if (this.hasSubmitTarget) {
        this.submitTarget.classList.add("btn-disabled")
      }
      
      // Submit the form
      this.element.requestSubmit()
    }, 300) // Wait 300ms after user stops typing
  }
  
  // Reset loading state after submission
  reset() {
    if (this.hasSubmitTarget) {
      this.submitTarget.classList.remove("btn-disabled")
    }
  }
}
