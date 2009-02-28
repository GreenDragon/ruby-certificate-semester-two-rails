class Group < ActiveRecord::Base
  has_many    :locations

  validates_presence_of :name
  validates_format_of   :url, :with => /^https?:\/\/.*$/i

  # TODO this seems to create reciprocal errors
  # validates_associated  :locations

  def self.sort_by_name
    Group.find(:all, :order => "upper(name) ASC")
  end

  def self.sort_by_location
    Group.find(:all, :include => :locations, :order => "locations.name")
  end

  #def self.sort_by_location_advanced
  #  # Code ala tenderlove
  #  g = Group.find(
  #    :all, 
  #    :include => :locations, 
  #    :order => "upper(locations.name) ASC"
  #  )
  #  g.map { |group| group.locations.map { |location| [group.id, group.name, location.name] } }
  #end

  define_index do
    # fields
    indexes :name,              :sortable => true
    indexes :alternate_name,    :sortable => true
    indexes :url,               :sortable => true

    indexes locations.name,     :as => :location_name
    indexes locations.address,  :as => :loctiona_address
    
    # attributes
    has created_at, updated_at
    #
    has locations(:id),         :as => :location_ids
  end
end
