class Event < ActiveRecord::Base
  belongs_to  :group
  belongs_to  :location

  define_index do
    # fields
    indexes :name,                :sortable => true
    indexes :description,         :sortable => true
    # attributes
    has start_date, end_date
    has created_at, updated_at
    has group_id, location_id
  end
end
