class AddDeltaToLocations < ActiveRecord::Migration
  def self.up
    add_column  :locations, :delta, :boolean, :default => false

    add_index   :locations, :delta
  end

  def self.down
    remove_index  :locations, :delta

    remove_column :locations, :delta
  end
end
