class AddUserToReadComments < ActiveRecord::Migration[5.1]
  def change
    add_reference :read_comments, :user, foreign_key: true
  end
end
