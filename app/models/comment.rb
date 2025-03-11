class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post

  has_many :likes, as: :likeable, dependent: :destroy
  has_many :liked_users, through: :likes, source: :user

  has_many :notifications, as: :notifiable, dependent: :destroy

  validates :body, presence: true, length: { maximum: 300 }

  def create_notification(visitor, action)
    # いいねユーザーとコメント作成者が同じ場合は通知を作成しない
    return if visitor.id == self.user.id

    Notification.create!(
      # current_userが入る
      visitor_id: visitor.id,
      # コメントしたユーザー
      visited_id: self.user.id,
      # 通知の対象、コメントが入る
      notifiable: self,
      # いいねが入る
      action: action
    )
  end
end
