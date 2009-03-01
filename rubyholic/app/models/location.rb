class Location < ActiveRecord::Base
  has_many  :events, :dependent => :destroy
  has_many  :groups, :through => :events, :dependent => :destroy

  validates_presence_of       :name
  validates_presence_of       :address

  validates_numericality_of   :latitude
  validates_numericality_of   :longitude

  # fail safe when geocode errors are not caught

  validates_presence_of       :latitude
  validates_presence_of       :longitude

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

private

  def geocode_address
    geo=GeoKit::Geocoders::MultiGeocoder.geocode(address)
    errors.add(:address, "Could not Geocode address") if !geo.success
    self.latitude, self.longitude = geo.lat,geo.lng   if geo.success
  end
end
