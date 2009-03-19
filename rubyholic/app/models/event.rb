class Event < ActiveRecord::Base
  # I want to set a class instance of duration with the idea 
  # of setting a time length of the meeting then calculate end_date
  # setting a attr_accessor breaks several tests, garr

  #attr_accessor :duration
  
  # Any meeting past 4 hours needs alcohol or other inbibment infusions
  
  DURATIONS = [
    [  30, "0.5 hours" ],
    [  60, "1   hour" ],
    [  90, "1.5 hours" ],
    [ 120, "2   hours" ],
    [ 150, "2.5 hours" ],
    [ 180, "3   hours" ],
    [ 210, "3.5 hours" ],
    [ 240, "4   hours" ]
  ]
  
  belongs_to  :group
  belongs_to  :location

  before_validation     :check_time

  validates_presence_of :name, :start_date, :end_date, :group_id, :location_id

  validates_datetime    :start_date, :end_date

  #def initialize
  #  # default duration of event in minutes, 2 hours
  #  @duration = 120
  #end

  define_index do
    # fields
    indexes :name,                :sortable => true
    indexes :description,         :sortable => true
    # attributes
    has start_date, end_date
    has created_at, updated_at
    has group_id, location_id
  end

private

  def check_time
    # TODO How do I specify errors on date fields?
    if ( self.end_date && self.start_date ) then
      unless ( ( self.end_date - self.start_date ) > 0 ) then
        errors.add(end_date, "End date can not be before the start date.")
        self.end_date = nil
      end
    end
  end

end
