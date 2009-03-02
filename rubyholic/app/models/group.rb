class Group < ActiveRecord::Base
  # I think this belongs in application.rb myself
  cattr_reader  :per_page
  @@per_page = 10

  has_many  :events, :dependent => :destroy
  has_many  :locations, :through => :events, :dependent => :destroy

  validates_presence_of :name, :url
  validates_format_of   :url, :with => /^https?:\/\/.*$/i

  def self.index(page)
    Group.paginate :all, :page => page, :include => "locations"
  end

  def self.sort(sort, page)
    Group.paginate :all, :page => page, :include => "locations",
                              :order => "upper(#{sort}) ASC"
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
    indexes :url,               :sortable => true
    indexes :description,       :sortable => true

    # indexes locations.name,     :as => :location_name
    # indexes locations.address,  :as => :location_address
    
    # attributes
    has created_at, updated_at
  end
end
