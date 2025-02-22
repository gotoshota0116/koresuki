class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post

  has_many :likes, as: :likeable, dependent: :destroy
  has_many :liked_users, through: :likes, source: :user

  has_many :notifications, as: :notifiable, dependent: :destroy

  validates :body, presence: true, length: { maximum: 300 }

  def create_notification(visitor)
    Notification.create!(
      visitor_id: visitor.id,
      visited_id: post.user.id,
      notifiable: self,
      action: :commented
    )
  end
end
