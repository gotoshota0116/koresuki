class CreatePosts < ActiveRecord::Migration[7.1]
  def change
    create_table :posts do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.string :title
      t.text :body
      t.string :image
      t.timestamps
    end
  end
end
