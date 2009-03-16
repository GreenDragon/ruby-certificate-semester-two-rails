require 'test_helper'

class LocationsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:locations)
  end

  test "should get new" do
    get :new
    assert_response :success
    assert_tag :tag => 'input', :attributes => {
      :name => 'location[name]'
    }
    assert_tag :tag => 'input', :attributes => {
      :name => 'location[address]'
    }
    assert_tag :tag => 'textarea', :attributes => {
      :name => 'location[notes]'
    }
  end

  test "should raise error when geocode is ambiguous" do
    post :create, :location => {
      :name     => "Ambiguous Vivace",
      :address  => "532 E Broadway Ave., Seattle, WA, USA"
    }

    assert_match /Ambiguous number of results found/, @response.body
  end

  test "should create location" do
    assert_difference('Location.count') do
      post :create, :location => { 
        :name     => "New Century Tea House", 
        :address  => "416 Maynard Ave S, Seattle, WA, USA"
      }
    end

    assert_redirected_to location_path(assigns(:location))
  end

  test "should show location" do
    get :show, :id => locations(:one).id
    assert_response :success
    assert_match /#{locations(:one).name}/, @response.body
    assert_match /#{locations(:one).address}/, @response.body
    assert_match /#{locations(:one).notes}/, @response.body
    assert_match /maps\.google\.com\/maps\?file/, @response.body
    assert_match /new GLatLng\(#{locations(:one).latitude},#{locations(:one).longitude}\)/, @response.body
  end

  test "should get edit" do
    get :edit, :id => locations(:one).id
    assert_response :success
    assert_tag :tag => 'input', :attributes => {
      :name => 'location[name]'
    }
    assert_tag :tag => 'input', :attributes => {
      :name => 'location[address]'
    }
    assert_tag :tag => 'textarea', :attributes => {
      :name => 'location[notes]'
    }
  end

  test "should update location" do
    put :update, :id => locations(:one).id, :location => { :name => "Change" }
    assert_redirected_to location_path(assigns(:location))
  end

  test "should destroy location" do
    assert_difference('Location.count', -1) do
      delete :destroy, :id => locations(:one).id
    end

    assert_redirected_to locations_path
  end
end
