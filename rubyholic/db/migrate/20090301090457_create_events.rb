class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.string    :name,        :null => false
      t.string    :description
      t.datetime  :start_date,  :null => false
      t.datetime  :end_date,    :null => false
      t.integer   :group_id,    :null => false
      t.integer   :location_id, :null => false

      t.timestamps
    end
    add_foreign_key :events, :groups
    add_foreign_key :events, :locations
  end

  def self.down
    remove_foreign_key :events, :group_id
    remove_foreign_key :events, :location_id
    drop_table :events
  end
end
