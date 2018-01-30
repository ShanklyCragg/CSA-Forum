class ReadComment < ApplicationRecord
  has_many :user, dependent: :destroy
  has_many :post, dependent: :destroy
  has_many :comment, dependent: :destroy
end
