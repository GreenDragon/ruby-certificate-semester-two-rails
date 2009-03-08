class Location < ActiveRecord::Base
  has_many  :events, :dependent => :destroy
  has_many  :groups, :through => :events, :dependent => :destroy

  validates_presence_of       :name, :address
  
  # fail safe when geocode errors are not caught since it's not null
  # it enters 0 when not found, need to intercept that in the future
  # or simply not allow 0,0 as lat/long

  validates_presence_of       :latitude, :longitude
  validates_numericality_of   :latitude, :longitude

  acts_as_mappable  :lat_column_name  => :latitude,
                    :lng_column_name  => :longitude,
                    :auto_geocode     => { :field => :address,
                      :error_message => 'Could not find geocode address'}

  before_validation           :geocode_address

  define_index do
    # fields
    indexes :name,                :sortable => true
    indexes :address,             :sortable => true
    indexes :notes,               :sortable => true
    #
    # indexes group.name,           :as => :group_name
    # indexes group.alternate_name, :as => :group_alternate_name
    # indexes group.url,            :as => :group_url
    # attributes
    has latitude, longitude
    has created_at, updated_at
  end

  def self.closest(origin)
    # Handle temporal lookup failures
    # TODO Need to mock lookups in test cases
    begin
      Location.find_closest(:origin => origin)
    rescue Geokit::Geocoders::GeocodeError
      nil
    end
  end

  def self.within(distance, origin)
    # TODO Need to mock up lookups in test cases
    begin
      Location.find_within(distance, :origin => origin)
    rescue Geokit::Geocoders::GeocodeError
      nil
    end
  end

private

  def geocode_address
    geo=GeoKit::Geocoders::MultiGeocoder.geocode(address)
    errors.add(:address, "Could not Geocode address") if !geo.success
    self.latitude, self.longitude = geo.lat,geo.lng   if geo.success
  end
end
