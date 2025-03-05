import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "output" ]

  connect() {
    setTimeout(() => {
      this.outputTarget.classList.add("fade-in")
      this.outputTarget.textContent = "Hello World!"
    }, 1000)
  }
}
