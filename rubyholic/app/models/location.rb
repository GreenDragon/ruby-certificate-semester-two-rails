class Location < ActiveRecord::Base
  belongs_to        :group
  acts_as_mappable  :lat_column_name  => :latitude,
                    :lng_column_name  => :longitude,
                    :auto_geocode     => { :field => :address,
                      :error_message => 'Could not find geocode address'}
                                            

#  before_validation_on_create :geocode_address

#private

#  def geocode_address
#    geo = Geokit::Geocoders::MultiGeocoder.geocode (address)
#    errors.add(:address, "Could not Geocode address") if !geo.success
#    self.latitude, self.longitude = geo.lat, geo.lng if geo.success
#  end
end
