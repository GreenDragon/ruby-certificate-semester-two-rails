class Group < ActiveRecord::Base
  has_many    :locations

  def self.sort_by_group_name
    Group.find(:all, :order => "name")
  end

  def self.sort_by_location_name
    Group.find(:all, :include => :locations, :order => "locations.name")
  end

  #def self.sort_by_location_name
  #  Group.find_by_sql "
  #    SELECT groups.name AS group_name, 
  #      locations.name AS location_name,
  #      latitude, longitude
  #    FROM locations 
  #    INNER JOIN groups ON locations.group_id = groups.id 
  #    ORDER BY locations.name"
  #end
end
