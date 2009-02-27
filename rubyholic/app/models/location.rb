class Location < ActiveRecord::Base
  belongs_to                  :group

  validates_presence_of       :name
  validates_presence_of       :address

  validates_numericality_of   :group_id
  validates_associated        :group

  validates_numericality_of   :latitude,  :on => :create
  validates_numericality_of   :longitude, :on => :create

  acts_as_mappable  :lat_column_name  => :latitude,
                    :lng_column_name  => :longitude,
                    :auto_geocode     => { :field => :address,
                      :error_message => 'Could not find geocode address'}
end
