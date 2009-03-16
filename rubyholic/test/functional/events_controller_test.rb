require 'test_helper'

class EventsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:events)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create event" do
    assert_difference('Event.count') do
      post :create, :event => { 
        :name         => "Seattle.rb @ Vivace's", 
        :start_date   => Time.now,
        :end_date     => Time.now + 2.hours,
        :group_id     => 1,
        :location_id  => 1
      }
    end

    assert_redirected_to event_path(assigns(:event))
  end

  test "should not create event if end time is not greater than start time" do
    time = Time.now
    post :create, :event => {
      :name         => "Seattle.rb @ Vivace's",
      :start_date   => time,
      :end_date     => time,
      :group_id     => 1,
      :location_id  => 1
    }
    assert_template "new"
  end

  test "should show event" do
    get :show, :id => events(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => events(:one).id
    assert_response :success
  end

  test "should update event" do
    put :update, :id => events(:one).id, :event => { :end_date => Time.now }
    assert_redirected_to event_path(assigns(:event))
  end

  test "should destroy event" do
    assert_difference('Event.count', -1) do
      delete :destroy, :id => events(:one).id
    end

    assert_redirected_to events_path
  end
end
