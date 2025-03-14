import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["template", "container"]
  
  // コントローラーが呼ばれたら実行される railsでいうと before_action,initialize
  connect() {
    console.log("Nested form controller connected")
  }
  
  // addメソッド　追加ボタン
  add(event) {
    event.preventDefault() // Railsでいうと remote: true
    
    // 親要素のdata-nested-form-target属性を取得
    const containerType = event.currentTarget.dataset.type
    const template = this.templateTargets.find(t => t.dataset.type === containerType)
    const container = this.containerTargets.find(c => c.dataset.type === containerType)
    
    // テンプレートからHTMLを取得し、一意のIDを生成して置換
    const content = template.innerHTML.replace(/NEW_RECORD/g, new Date().getTime())
    
    // フォームコンテナに追加
    container.insertAdjacentHTML('beforeend', content)
  }
  
  // removeメソッド 削除ボタン
  remove(event) {
    event.preventDefault() // Railsでいうと remote: true
    
    const wrapper = event.target.closest('.nested-form-wrapper')
    
    // hidden _destroy フィールドがある場合（既存レコード）
    if (wrapper.querySelector("input[name*='_destroy']")) {
      wrapper.querySelector("input[name*='_destroy']").value = 1
      wrapper.style.display = 'none'
    } else {
      // 新規追加したフォームの場合は単にDOM削除
      wrapper.remove()
    }
  }
}