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
  end

  def self.down
    drop_table :locations
  end
end
