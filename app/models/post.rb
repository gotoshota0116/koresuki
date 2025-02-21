class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  # ポリモーフィック関連付けに変更
  has_many :likes, as: :likeable, dependent: :destroy
  has_many :liked_users, through: :likes, source: :user

  mount_uploader :image, ImageUploader

  validates :title, presence: true
  validates :body, presence: true
end
