class DropPostsTable < ActiveRecord::Migration[7.1]
  def up
    drop_table :posts, if_exists: true
  end

  def down
    create_table :posts, id: :integer do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.string :title, null: false
      t.text :body, null: false
      t.string :image
      t.timestamps
    end
  end
end
