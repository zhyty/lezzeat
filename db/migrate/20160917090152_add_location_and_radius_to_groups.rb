class AddLocationAndRadiusToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :location, :string
    add_column :groups, :radius, :integer
  end
end
