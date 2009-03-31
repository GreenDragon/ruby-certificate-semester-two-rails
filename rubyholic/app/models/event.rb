class Event < ActiveRecord::Base

  named_scope :sort_by_start_date, :order => "start_date, name"
  named_scope :current_events, :conditions => [ "start_date > ?", Time.now ]

  # Any meeting past 4 hours needs alcohol or other inbibment infusions
  
  DURATIONS = [
    [ "0.5 hours",  30 ],
    [ "1   hour ",  60 ],
    [ "1.5 hours",  90 ],
    [ "2   hours", 120 ],
    [ "2.5 hours", 150 ],
    [ "3   hours", 180 ],
    [ "3.5 hours", 210 ],
    [ "4   hours", 240 ]
  ]
  
  belongs_to  :group
  belongs_to  :location

  before_save :calculate_end_date

  validates_presence_of :name, :start_date, :duration, :group_id, :location_id

  validates_datetime    :start_date 

  validates_numericality_of :duration,
    :greater_than => 0,
    :less_than    => 24*60

  validates_numericality_of :group_id, :location_id

  define_index do
    # fields
    indexes :name,                :sortable => true
    indexes :description,         :sortable => true
    # attributes
    has start_date, end_date
    has created_at, updated_at
    has group_id, location_id

    set_property :delta => true
  end

private
  def calculate_end_date
    self.end_date = self.start_date + ( self.duration * 60 )
  end
end
