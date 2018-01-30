json.extract! post, :id, :title, :body, :is_anon, :user_id, :created_at, :updated_at
json.url api_post_url(post, format: :json)
