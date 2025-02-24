class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post

  has_many :likes, as: :likeable, dependent: :destroy
  has_many :liked_users, through: :likes, source: :user

  has_many :notifications, as: :notifiable, dependent: :destroy

  validates :body, presence: true, length: { maximum: 300 }

  def create_notification(visitor, action)
    # いいね、コメントしたユーザーと投稿者が同じ場合は通知を作成しない
    return if visitor.id == post.user.id

    Notification.create!(
      # current_userが入る
      visitor_id: visitor.id,
      # 投稿者
      visited_id: post.user.id,
      # コメントが入る
      notifiable: self,
      # いいねかコメントが入る
      action: action
    )
  end
end
