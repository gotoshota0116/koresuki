class PostVideo < ApplicationRecord
  belongs_to :post

  before_save :split_id_from_youtube_url

  validates :youtube_url, presence: true, length: { maximum: 255 }
  validates :caption, length: { maximum: 65_535 }

  def split_id_from_youtube_url
    self.youtube_url = youtube_url.split('/').last
  end
end
