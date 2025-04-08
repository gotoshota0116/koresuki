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

  validates :name, presence: true, length: { maximum: 255 }
  validates :uid, uniqueness: { scope: :provider }, allow_nil: true

  def own?(object)
    id == object&.user_id
  end

  def like(likeable)
    likes.create(likeable: likeable)
  end

  def unlike(likeable)
    likes.find_by(likeable: likeable)&.destroy
  end

  def bookmark(post)
    bookmarks.create(post: post)
  end

  def unbookmark(post)
    bookmark_posts.destroy(post)
  end

  def self.from_omniauth(auth)
    user = where(provider: auth.provider, uid: auth.uid).first # google認証しているユーザーを検索

    return user if user.present?

    user = find_by(email: auth.info.email) # 既存の `email` を持つユーザーを検索（メール & パスワード登録済みユーザー）
    if user
      # 既存ユーザーに Google 認証情報を紐付ける
      user.update(provider: auth.provider, uid: auth.uid)
    else
      user = new(
        provider: auth.provider,
        uid: auth.uid,
        email: auth.info.email,
        name: auth.info.name,
        password: Devise.friendly_token[0, 20]
        # user.avatar = auth.info.image
      )
      user.skip_confirmation! # confirmed_at: Time.current
      user.save!
    end
    user
  end
end
