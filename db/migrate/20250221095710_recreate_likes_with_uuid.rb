class RecreateLikesWithUuid < ActiveRecord::Migration[7.0]
  def up
    drop_table :likes, if_exists: true

    create_table :likes, id: :uuid do |t|
      t.uuid :user_id, null: false
      t.uuid :likeable_id, null: false
      t.string :likeable_type, null: false
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
      t.index ["likeable_id", "likeable_type"], name: "index_likes_on_likeable"
      t.index ["user_id", "likeable_id", "likeable_type"], name: "index_likes_on_user_id_and_likeable", unique: true
      t.index ["user_id"], name: "index_likes_on_user_id"
    end
  end

  def down
    drop_table :likes, if_exists: true

    create_table :likes do |t|
      t.bigint :user_id, null: false
      t.bigint :likeable_id, null: false
      t.string :likeable_type, null: false
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
      t.index ["likeable_id", "likeable_type"], name: "index_likes_on_likeable"
      t.index ["user_id", "likeable_id", "likeable_type"], name: "index_likes_on_user_id_and_likeable", unique: true
      t.index ["user_id"], name: "index_likes_on_user_id"
    end
  end
end
