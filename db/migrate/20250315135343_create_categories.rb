class CreateCategories < ActiveRecord::Migration[7.1]
  def change
    create_table :categories, id: :uuid do |t|
      t.string :name, null: false

      t.timestamps
    end
    add_index :categories, :name, unique: true
  end
end
