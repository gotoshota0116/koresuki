class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :likes, as: :likeable, dependent: :destroy
  has_many :liked_users, through: :likes, source: :user
  has_many :notifications, as: :notifiable, dependent: :destroy
  has_many :post_images, dependent: :destroy
  accepts_nested_attributes_for :post_images, allow_destroy: true, reject_if: :all_blank
  has_many :post_videos, dependent: :destroy
  accepts_nested_attributes_for :post_videos, allow_destroy: true, reject_if: :all_blank
  has_many :post_categories, dependent: :destroy
  has_many :categories, through: :post_categories
  has_many :bookmarks, dependent: :destroy

  mount_uploader :image, ImageUploader

  validates :title, presence: true, length: { maximum: 255 }
  validates :body, presence: true, length: { maximum: 65_535 }
  validates :categories, presence: true

  # 投稿にいいね作成時呼び出し
  def create_notification(visitor, action)
    # いいねしたユーザーと投稿者が同じ場合は通知を作成しない
    return if visitor.id == user.id

    # find_or_create_by　既存のレコードを取得,存在しない場合は新しく作成
    # いいねを複数回押しても1回分の通知しか作成されないように
    Notification.find_or_create_by(
      visitor_id: visitor.id, # current_user
      visited_id: user.id, # 投稿者
      notifiable: self, # 通知元、like
      action: action # liked
    )
  end
end
