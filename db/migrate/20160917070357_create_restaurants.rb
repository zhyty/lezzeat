class CreateRestaurants < ActiveRecord::Migration
  def change
    create_table :restaurants do |t|
      t.belongs_to :group
      t.string :name
      t.string :address
      t.string :image_url
      t.boolean :is_closed

      t.float :rating
      t.float :distance
      t.integer :review_count
      t.integer :user_votes
    end
  end
end
