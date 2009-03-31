class AddDeltaToGroups < ActiveRecord::Migration
  def self.up
    add_column  :groups, :delta, :boolean, :default => false
    
    add_index   :groups, :delta
  end

  def self.down
    remove_index  :groups, :delta

    remove_column :groups, :delta
  end
end
