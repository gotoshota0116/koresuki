class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post

  has_many :likes, as: :likeable, dependent: :destroy
  has_many :notifications, as: :notifiable, dependent: :destroy

  validates :body, presence: true, length: { maximum: 65_535 }

  # 　呼び出される時
  # 1コメントに対していいね作成時 2コメント作成時（else)
  def create_notification(visitor, action)
    if action == :liked
      # いいねした人とコメント作成者が同じ場合は通知しない
      return if visitor.id == user.id

      # 同じコメントに繰り返しいいねの通知を防ぐため、find_or_create_by
      Notification.find_or_create_by(
        visitor_id: visitor.id, # current_user
        visited_id: user.id, # コメント作成者
        notifiable: self, # 通知元、comment
        action: action # liked
      )
    else # コメント作成時
      # コメントしたユーザーと投稿作成者が同じ場合は通知を作成しない
      return if visitor.id == post.user.id

      Notification.create(
        visitor_id: visitor.id, # current_user
        visited_id: post.user.id, # 投稿作成者
        notifiable: self, # 通知元、comment
        action: action # commented
      )
    end
  end
end
