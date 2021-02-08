class CreatePostsTagsJoinTable < ActiveRecord::Migration[5.1]
  def change
    add_foreign_key :posts, :users, foreign_key: true
  end
end
