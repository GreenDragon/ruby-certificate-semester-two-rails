class AddDeltaToEvents < ActiveRecord::Migration
  def self.up
    add_column  :events, :delta, :boolean, :default => false

    add_index   :events, :delta
  end

  def self.down
    remove_index  :events, :delta

    remove_column :events, :delta
  end
end
