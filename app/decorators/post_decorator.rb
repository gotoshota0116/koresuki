class PostDecorator < Draper::Decorator
  delegate_all

  # サブ画像、youtubeリンクの投稿フォームを生成する
  def prepare_nested_forms
    ensure_nested_form_items(object.post_images)
    ensure_nested_form_items(object.post_videos)
  end

  # 常に4つのフォームを表示するため、不足分のオブジェクトを追加
  # 既存の入力があれば保持し、合計が指定数になるようにbuild
  def ensure_nested_form_items(association, count = 0)
    (count - association.size).times { association.build }
  end
end
