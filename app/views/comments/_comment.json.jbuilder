json.extract! comment, :id, :title, :body, :is_anon, :parent_id, :post_id, :user_id, :created_at, :updated_at
json.url comment_url(comment, format: :json)
