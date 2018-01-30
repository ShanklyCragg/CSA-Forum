class AddPostToReadComments < ActiveRecord::Migration[5.1]
  def change
    add_reference :read_comments, :post, foreign_key: true
  end
end
