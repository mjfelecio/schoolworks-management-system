import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="theme"
export default class extends Controller {
  static targets = ["toggle"]

  connect() {
    const saved = localStorage.getItem("theme")

    if (saved) {
      document.documentElement.setAttribute("data-theme", saved)
      this.toggleTarget.checked = saved === "dark"
    } else {
      // fallback to system preference
      const prefersLight = window.matchMedia("(prefers-color-scheme: light)").matches
      const defaultTheme = prefersLight ? "light" : "dark"

      document.documentElement.setAttribute("data-theme", defaultTheme)
      this.toggleTarget.checked = defaultTheme === "dark"
    }
  }

  change() {
    const theme = this.toggleTarget.checked ? "dark" : "light"
    document.documentElement.setAttribute("data-theme", theme)
    localStorage.setItem("theme", theme)
  }
}
