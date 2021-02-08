class AddUserInPosts < ActiveRecord::Migration[5.1]
  def change
    add_foreign_key :users, :posts
  end
end
