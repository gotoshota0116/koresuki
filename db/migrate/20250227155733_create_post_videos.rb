class CreatePostVideos < ActiveRecord::Migration[7.1]
  def change
    create_table :post_videos, id: :uuid, default: -> { "gen_random_uuid()" } do |t|
      t.references :post, null: false, foreign_key: true, type: :uuid
      t.string :youtube_url
      t.text :caption

      t.timestamps
    end
  end
end
