class Group < ActiveRecord::Base
  has_many    :locations

  validates_presence_of :name
  validates_format_of   :url, :with => /^http.*$/i

  def self.sort_by_name
    Group.find(:all, :order => "upper(name) ASC")
  end

  def self.sort_by_location
    # Code ala tenderlove
    g = Group.find(
      :all, 
      :include => :locations, 
      :order => "upper(locations.name) ASC"
    )
    g.map { |group| group.locations.map { |location| [group.id, group.name, location.name] } }
  end
end
