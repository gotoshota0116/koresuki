class PostImage < ApplicationRecord
  belongs_to :post

  validates :image ,presence: true, length: {maximum: 255 }
  validates :caption, length: {maximum: 65_535 }

  mount_uploader :image, PostImageUploader
end
