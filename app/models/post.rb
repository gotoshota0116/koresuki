class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  
  has_many :likes, as: :likeable, dependent: :destroy
  has_many :liked_users, through: :likes, source: :user

  has_many :notifications, as: :notifiable, dependent: :destroy

  mount_uploader :image, ImageUploader

  validates :title, presence: true
  validates :body, presence: true

  def create_notification(visitor, action)
    notification = Notification.find_or_initialize_by(
      visitor_id: visitor.id,
      visited_id: user.id,
      notifiable: self,
      action: action
    )

    notification.save if notification.new_record?
  end
end
