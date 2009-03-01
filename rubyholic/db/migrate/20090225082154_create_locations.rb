class CreateLocations < ActiveRecord::Migration
  def self.up
    create_table :locations do |t|
      t.string  :name,      :null => false
      t.string  :address,   :null => false
      t.text    :notes
      t.float   :latitude,  :null => false
      t.float   :longitude, :null => false

      t.timestamps
    end
    add_index :locations, :name,    :unique => true
    add_index :locations, :address, :unique => true
  end

  def self.down
    drop_table :locations
  end
end
