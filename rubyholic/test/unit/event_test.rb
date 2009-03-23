require 'test_helper'

class EventTest < ActiveSupport::TestCase
  def assert_save_failure(event)
    assert_raise ActiveRecord::RecordInvalid do
      event.save!
    end
  end

  test "should create a valid record" do
    event = Event.create( {
      :name         => "Special Seattle.RB Monthly Meeting",
      :description  => "_why is flying into town with his band!",
      :start_date   => "2009-03-30 17:00:00",
      :duration     => 120,
      :group_id     => 1,
      :location_id  => 1
    } )
    assert event.valid?
  end

  test "event is invalid when missing name" do
    event = Event.create( {
      :description  => "_why is flying into town with his band!",
      :start_date   => "2009-03-30 17:00:00",
      :end_date     => "2009-03-30 21:00:00",
      :group_id     => 1,
      :location_id  => 1
    } )
    assert event.errors.on(:name)
    assert_save_failure(event)
  end

  test "event is invalid when missing start_date" do
    event = Event.create( {
      :name         => "Special Seattle.RB Monthly Meeting",
      :description  => "_why is flying into town with his band!",
      :end_date     => "2009-03-30 21:00:00",
      :group_id     => 1,
      :location_id  => 1
    } )
    assert event.errors.on(:start_date)
    assert_save_failure(event)
  end

  test "event is invalid when missing duration" do
    event = Event.create( {
      :name         => "Special Seattle.RB Monthly Meeting",
      :description  => "_why is flying into town with his band!",
      :start_date   => "2009-03-30 17:00:00",
      :group_id     => 1,
      :location_id  => 1
    } )
    assert event.errors.on(:duration)
    assert_save_failure(event)
  end

  test "event is invalid when missing group_id" do
    event = Event.create( {
      :name         => "Special Seattle.RB Monthly Meeting",
      :description  => "_why is flying into town with his band!",
      :start_date   => "2009-03-30 17:00:00",
      :end_date     => "2009-03-30 21:00:00",
      :location_id  => 1
    } )
    assert event.errors.on(:group_id)
    assert_save_failure(event)
  end

  test "event is invalid when duration is not greater than zero" do
    event = Event.create( {
      :name         => "Seattle.rb @ Vivace's",
      :start_date   => Time.now,
      :duration     => 0,
      :group_id     => 1,
      :location_id  => 1
    } )
    assert_save_failure(event)
  end

  test "event is invalid when duration is greater than one day" do
    event = Event.create( {
      :name         => "Seattle.rb @ Vivace's",
      :start_date   => Time.now,
      :duration     => 24*60,
      :group_id     => 1,
      :location_id  => 1
    } )
    assert_save_failure(event)
  end

  test "event is invalid when group_id invalid" do
    assert_raises ActiveRecord::StatementInvalid do
      event = Event.create( {
        :name         => "Special Seattle.RB Monthly Meeting",
        :description  => "_why is flying into town with his band!",
        :start_date   => "2009-03-30 17:00:00",
        :duration     => 120,
        :group_id     => 666,
        :location_id  => 1
      } )
    end
  end

  test "event is invalid when missing location_id" do
    event = Event.create( {
      :name         => "Special Seattle.RB Monthly Meeting",
      :description  => "_why is flying into town with his band!",
      :start_date   => "2009-03-30 17:00:00",
      :end_date     => "2009-03-30 21:00:00",
      :group_id     => 1,
    } )
    assert event.errors.on(:location_id)
    assert_save_failure(event)
  end

  test "event is invalid when location_id invalid" do
    assert_raises ActiveRecord::StatementInvalid do
      event = Event.create( {
        :name         => "Special Seattle.RB Monthly Meeting",
        :description  => "_why is flying into town with his band!",
        :start_date   => "2009-03-30 17:00:00",
        :duration     => 120,
        :group_id     => 1,
        :location_id  => 666
      } )
    end
  end
end
