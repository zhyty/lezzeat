class AddUserVotesToRestaurants < ActiveRecord::Migration
  def change
    add_column :restaurants, :user_votes, :integer
  end
end
