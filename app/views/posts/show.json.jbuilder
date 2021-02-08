json.(@post, :id, :title, :description, :created_at, :updated_at)
json.comments(@comments, :id, :text, :user, :updated_at)
json.tags(@tags, :name)
json.author(@author, :name)
