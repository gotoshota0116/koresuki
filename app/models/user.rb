class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable

  has_many :posts, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_posts, through: :likes, source: :post

  validates :name, presence: true, length: { maximum: 30 }

  def own?(object)
    id == object&.user_id
  end

  # likesコントローラーで使用
  def like(post)
    likes.create(post: post)
  end
  
  def unlike(post)
    liked_posts.destroy(post)
  end
  
  def like?(post)
    liked_posts.include?(post)
  end
end
