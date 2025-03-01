class PostVideo < ApplicationRecord
  belongs_to :post

  before_save :split_id_from_youtube_url

  def split_id_from_youtube_url
    self.youtube_url = youtube_url.split('/').last
  end
end
