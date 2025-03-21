class CreateBookmarks < ActiveRecord::Migration[7.1]
  def change
    create_table :bookmarks, id: :uuid do |t|
      t.references :post, null: false, foreign_key: true, type: :uuid
      t.references :user, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
    add_index :bookmarks, [:post_id, :user_id], unique: true
  end
end
