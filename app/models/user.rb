class User < ApplicationRecord
  has_many :microposts
  validates :name, :email, presence: true    # checking for the name of user
end

