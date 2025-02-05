class AddNullConstraintToPosts < ActiveRecord::Migration[7.1]
  def change
    change_column_null :posts, :title, false
    change_column_null :posts, :body, false
  end
end
