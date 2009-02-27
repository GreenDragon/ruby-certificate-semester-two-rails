class RemoveReservedWordFromGroups < ActiveRecord::Migration
  def self.up
    rename_column "groups", "alias", "alternate_name"
  end

  def self.down
    rename_column "groups", "alternate_name", "alias"
  end
end
