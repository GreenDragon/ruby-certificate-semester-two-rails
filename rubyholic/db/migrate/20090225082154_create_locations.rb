class CreateLocations < ActiveRecord::Migration
  def self.up
    create_table :locations do |t|
      t.string  :name,      :null => false
      t.string  :address,   :null => false
      t.text    :notes
      t.decimal :latitude,  :null => false, :precision => 15, :scale => 10
      t.decimal :longitude, :null => false, :precision => 15, :scale => 10

      t.timestamps
    end
    add_index :locations, :name,                    :unique => true
    add_index :locations, :address,                 :unique => true
    add_index :locations, [ :latitude, :longitude], :unique => true
  end

  def self.down
    drop_table :locations
  end
end
