class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  has_many :liked_posts, through: :likes, source: :likeable, source_type: 'Post', dependent: :destroy
  has_many :liked_comments, through: :likes, source: :likeable, source_type: 'Comment', dependent: :destroy

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

  def like?(likeable)
    likes.exists?(likeable: likeable)
  end
end
