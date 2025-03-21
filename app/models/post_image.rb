class PostImage < ApplicationRecord
  belongs_to :post

  validates :image, presence: true
  validates :caption, length: { maximum: 65_535 }

  mount_uploader :image, PostImageUploader
end
