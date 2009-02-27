class Group < ActiveRecord::Base
  has_many    :locations

  validates_presence_of :name
  validates_format_of   :url, :with => /^http.*$/i

  validates_associated  :locations

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

  define_index do
    # fields
    indexes name,   :sortable => true
    # ouch! reserved word, frakking thing
    # indexes alias,  :sortable => true
    indexes url,    :sortable => true

    indexes locations.name,     :as => :location_name
    indexes locations.address,  :as => :address
    
    # attributes
    has created_at
    has updated_at
  end
end
