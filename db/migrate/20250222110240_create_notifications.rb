class CreateNotifications < ActiveRecord::Migration[7.1]
  def change
    create_table :notifications, id: :uuid do |t|
      t.references :visitor, null: false, foreign_key: { to_table: :users }, type: :uuid
      t.references :visited, null: false, foreign_key: { to_table: :users }, type: :uuid
      t.references :notifiable, polymorphic: true, null: false, type: :uuid
      t.integer :action, null: false
      t.boolean :checked, null: false, default: false

      t.timestamps
    end
  end
end
