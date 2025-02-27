class PostVideo < ApplicationRecord
  belongs_to :post

  before_save :split_id_from_youtube_url


  def split_id_from_youtube_url
    # YoutubeならIDのみ抽出
    youtube_url.split('/').last
  end
end
