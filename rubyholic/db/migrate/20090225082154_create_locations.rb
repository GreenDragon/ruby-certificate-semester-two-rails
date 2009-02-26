class CreateLocations < ActiveRecord::Migration
  def self.up
    create_table :locations do |t|
      t.string :name
      t.string :address
      t.float :latitude
      t.float :longitude

      t.integer :group_id

      t.timestamps
    end
    add_foreign_key :locations, :groups
  end

  def self.down
    remove_foreign_key :groups, :group_id
    drop_table :locations
  end
end
