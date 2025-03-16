class CreatePostCategories < ActiveRecord::Migration[7.1]
  def change
    create_table :post_categories, id: :uuid do |t|
      t.references :post, null: false, foreign_key: true, type: :uuid
      t.references :category, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
    add_index :post_categories, [:post_id, :category_id], unique: true
  end
end
