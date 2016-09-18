class CreateUsers < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :location
      t.integer :radius
      t.string :code
      t.timestamps null: false
    end

    create_table :users do |t|
      t.belongs_to :group

      t.timestamps null: false
    end
  end
end
