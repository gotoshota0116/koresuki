class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post

  has_many :likes, as: :likeable, dependent: :destroy
  has_many :liked_users, through: :likes, source: :user

  has_many :notifications, as: :notifiable, dependent: :destroy

  validates :body, presence: true, length: { maximum: 300 }

  def create_notification(visitor, action)
    Notification.create!(
      # visitorにはcurrent_user（コメントしたユーザー）が入る
      visitor_id: visitor.id,
      # visitedにはpost.user（投稿者）が入る
      visited_id: post.user.id,
      # notifiableにはself（コメント）が入る
      notifiable: self,
      # actionにはaction（コメント）が入る
      action: action
    )
  end
end
