class Group < ActiveRecord::Base
  cattr_reader  :per_page
  @@per_page = 10

  has_many  :events, :dependent => :destroy
  has_many  :locations, :through => :events, :dependent => :destroy

  validates_presence_of :name, :url

# real simple, yeah
  validates_format_of   :url, 
    :with     => /^https?:\/\/.*$/i,
    :message  => "URL doesn't seem valid. Valid format is http://...",
    :allow_nil  => true

  named_scope :sort_by_name,
                :order => 'name ASC',
                :include => "locations"
  named_scope :sort_by_location,
                :order => 'locations.name ASC', 
                :include => "locations"

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

    indexes locations(:name),     :as => :location_name,      :sortable => true
    indexes locations(:address),  :as => :location_address,   :sortable => true

    indexes events(:name),        :as => :event_name,         :sortable => true
    indexes events(:description), :as => :event_description,  :sortable => true
    
    # attributes
    has created_at, updated_at

    # Hrm, seems to break during index rebuild
    #has events.start_date, events.stop_date

    # causes undefined method 'delta=' errors
    set_property :delta => true
  end
end
