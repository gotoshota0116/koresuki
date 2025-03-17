class PostCategory < ApplicationRecord
  belongs_to :post
  belongs_to :category

  validates :category_id, uniqueness: { scope: :post_id }
end
