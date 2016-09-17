class Group < ActiveRecord::Base
  # users, id, restaurants
  has_many :users
  has_many :restaurants
end