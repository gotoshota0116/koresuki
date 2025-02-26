class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :likes, as: :likeable, dependent: :destroy
  has_many :liked_users, through: :likes, source: :user
  has_many :notifications, as: :notifiable, dependent: :destroy
  has_many :post_images, dependent: :destroy

  mount_uploader :image, ImageUploader

  validates :title, presence: true
  validates :body, presence: true

  def create_notification(visitor, action)
    # いいね、コメントしたユーザーと投稿者が同じ場合は通知を作成しない
    return if visitor.id == user.id

    # find_or_initialize_by　既存のレコードを取得,存在しない場合は新しく作成
    # いいねを複数回押しても1回分の通知しか作成されないように
    notification = Notification.find_or_initialize_by(
      visitor_id: visitor.id,
      visited_id: user.id,
      notifiable: self,
      action: action
    )

    notification.save
  end
end
