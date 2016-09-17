class DropRestaurantsAndRedo < ActiveRecord::Migration
  def change
    create_table :restaurants do |t|
      t.belongs_to :group
      t.string :name
      t.integer :rating
      t.time :start_hour
      t.time :end_hour
      t.integer :user_votes
    end
  end

  def down
    drop_table :restaurants
  end
end
