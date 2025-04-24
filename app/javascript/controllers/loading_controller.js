import { Controller } from "@hotwired/stimulus"

// Controller for showing loading spinner during form submission
export default class extends Controller {
  static targets = ["spinner"]

  // 初期値
  connect() {
    this.hide()
  }

  hide() {
    this.spinnerTarget.classList.add("hidden")
  }

  // hiddenを削除して表示
  show() {
    this.spinnerTarget.classList.remove("hidden")
  }

}