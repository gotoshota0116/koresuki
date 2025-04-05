class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :omniauthable, omniauth_providers: [:google_oauth2]

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :active_notifications, class_name: 'Notification', inverse_of: :visitor, foreign_key: 'visitor_id', dependent: :destroy
  has_many :passive_notifications, class_name: 'Notification', inverse_of: :visited, foreign_key: 'visited_id', dependent: :destroy
  has_many :bookmarks, dependent: :destroy

  # 　下記プロフィール画面で使用予定
  has_many :liked_posts, through: :likes, source: :likeable, source_type: 'Post', dependent: :destroy
  has_many :liked_comments, through: :likes, source: :likeable, source_type: 'Comment', dependent: :destroy
  has_many :bookmark_posts, through: :bookmarks, source: :post

  mount_uploader :avatar, AvatarUploader

  validates :name, presence: true, length: { maximum: 30 }

  def own?(object)
    id == object&.user_id
  end

  # likesコントローラーで使用
  def like(likeable)
    likes.create(likeable: likeable)
  end

  def unlike(likeable)
    likes.find_by(likeable: likeable)&.destroy
  end

  # bookmarkコントローラーで使用
  def bookmark(post)
    bookmarks.create(post: post)
  end

  def unbookmark(post)
    bookmark_posts.destroy(post)
  end
end
