class Location < ActiveRecord::Base
  belongs_to        :group
  acts_as_mappable  :lat_column_name  => :latitude,
                    :lng_column_name  => :longitude,
                    :auto_geocode     => { :field => :address,
                      :error_message => 'Could not find geocode address'}
end
