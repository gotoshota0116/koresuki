import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["template", "container"]
  
  // ログに出力
  connect() {
    console.log("Nested form controller connected")
  }
  
  add(event) {
    event.preventDefault()
    
    // イベント発火のdata-type
    const containerType = event.currentTarget.dataset.type

    // ターゲットtemplate
    const template = this.templateTargets.find(t => t.dataset.type === containerType)

     // templateからHTMLを取得
    const content = template.innerHTML.replace(/NEW_RECORD/g, new Date().getTime())

    // 追加先のターゲットcontainer
    const container = this.containerTargets.find(c => c.dataset.type === containerType)

    // containerの一番下にHTML追加
    container.insertAdjacentHTML('beforeend', content)
  }
  
  remove(event) {
    event.preventDefault()
    
    // 削除対象のフォームを取得
    const wrapper = event.target.closest('.nested-form-wrapper')
    
    // 既存レコードがある場合、hidden _destroyを1にする
    if (wrapper.querySelector("input[name*='_destroy']")) {
      wrapper.querySelector("input[name*='_destroy']").value = 1
      wrapper.style.display = 'none'
    } else {
      // 新規追加したフォームの場合は単にDOM削除
      wrapper.remove()
    }
  }
}