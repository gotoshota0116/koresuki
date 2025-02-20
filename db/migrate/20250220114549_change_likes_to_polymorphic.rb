class ChangeLikesToPolymorphic < ActiveRecord::Migration[7.0]
  def up
    remove_index :likes, name: "index_likes_on_post_id" if index_exists?(:likes, :post_id)
    remove_index :likes, name: "index_likes_on_user_id_and_post_id" if index_exists?(:likes, [:user_id, :post_id])

    remove_column :likes, :post_id, :uuid

    add_column :likes, :likeable_id, :uuid, null: false
    add_column :likes, :likeable_type, :string, null: false

    add_index :likes, [:likeable_id, :likeable_type], name: "index_likes_on_likeable"
    add_index :likes, [:user_id, :likeable_id, :likeable_type], unique: true, name: "index_likes_on_user_id_and_likeable"
  end

  #ロールバックようにdown記載

  def down
    remove_index :likes, name: "index_likes_on_likeable"
    remove_index :likes, name: "index_likes_on_user_id_and_likeable"

    remove_column :likes, :likeable_id
    remove_column :likes, :likeable_type

    add_column :likes, :post_id, :uuid, null: false

    add_index :likes, :post_id, name: "index_likes_on_post_id"
    add_index :likes, [:user_id, :post_id], unique: true, name: "index_likes_on_user_id_and_post_id"
  end
end
