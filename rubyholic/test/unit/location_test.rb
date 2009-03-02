require 'test_helper'

class LocationTest < ActiveSupport::TestCase
  def assert_save_failure(location)
    assert_raise ActiveRecord::RecordInvalid do
      location.save!
    end
  end

  test "location is invalid when missing name" do
    location = Location.create( {
      :address  => "416 Maynard Ave S, Seattle, WA",
    })
    assert location.errors.on(:name)
    assert_save_failure(location) 
  end

  test "location is invalid when name is not unique" do
    assert_raises ActiveRecord::StatementInvalid do
      location = Location.create( {
        :name     => "Vivace Espresso Bar at Brix",
        :address  => "532 Broadway Ave. East, Seattle, WA, USA"
      } )
    end
  end

  test "location is invalid when missing address" do
    location = Location.create( {
      :name     => "Missing Address",
    })
    assert location.errors.on(:address)
    assert_save_failure(location)
  end

  # Hrmm, at some point, it should be a unique index of 
  # name + address, since business may change @ address
  # Also, some loose matching of address names,
  # or break up address string into atomic components
  # Lat/long doesn't work since business rise and fall

  test "location is invalid when address is not unique" do
    assert_raises ActiveRecord::StatementInvalid do
      location = Location.create( {
        :name     => "New Century Tea House",
        :address  => "532 Broadway Ave. East, Seattle, WA, USA"
      } )
    end
  end

  test "providing a valid address generates good geocode result" do
    location = Location.create( { 
      :name     => "New Century Tea House",
      :address  => "416 Maynard Ave S, Seattle, WA, USA",
    } )
    assert_valid(location)
    location.save!
    assert_equal   47.5990131, location.latitude
    assert_equal -122.325085,  location.longitude
  end

  # WARNING! This test is fragile if you change from [:google,:us] in
  # Geokit::Geocoders::provider_order !!
 
  test "setting an ambiguous address generates a geocode error" do
    location = Location.create( {
      :name     => "Chicago Bad House",
      :address  => "200 E. Randolph, 25th Floor, Chicago, IL, USA"
    } )
    assert location.errors.on(:address)
    assert_save_failure(location)
  end

  test "updating the location address and name triggers a new geocode lookup" do
    location = Location.find(:first)
    loc_address = location.address.clone
    loc_name = location.name.clone
    #
    location.name = "Floating Tea Leaves"
    location.address = "1704 NW Market St., Seattle, WA"
    assert location.save!
    assert_equal "Floating Tea Leaves", location.name
    assert_equal   47.66867,   location.latitude
    assert_equal -122.3789849, location.longitude
    #
    # rollback to known data so other unit tests don't blow up
    location.name = loc_name
    location.address = loc_address
    assert location.save!
    assert_equal "Vivace Espresso Bar at Brix", location.name
    assert_equal   47.6065233, location.latitude
    assert_equal -122.3207549, location.longitude
  end

  test "should find closest group location by address" do
    location = Location.closest("Seattle, WA")
    assert_equal 1, location.id
  end

  test "should find closest group location by zipcode" do
    location = Location.closest("98144")
    assert_equal 1, location.id
  end

  test "should find closest location by address within given distance" do
    location = Location.within(10, "Bellevue, WA")
    assert_equal 1, location[0].id
  end

  # How to start/stop rake ts:start/ts:stop from test suites?
  # Or sanity check that think_sphinx interface is running?
  # scan for pid? 
  #
  # Garr! test fails!
  #
#>> res = Location.search("Seattle")
#=> [#<Location id: 1, name: "Vivace Espresso Bar at Brix", address: "532 Broadway Ave. East, Seattle, WA, USA", latitude: 47.6065, longitude: -122.321, group_id: 1, created_at: "2009-02-26 07:01:00", updated_at: "2009-02-26 07:01:00">]
#>> res.first
#=> #<Location id: 1, name: "Vivace Espresso Bar at Brix", address: "532 Broadway Ave. East, Seattle, WA, USA", latitude: 47.6065, longitude: -122.321, group_id: 1, created_at: "2009-02-26 07:01:00", updated_at: "2009-02-26 07:01:00">
#>> res.first.name
#=> "Vivace Espresso Bar at Brix"
  #
  # More development db vs fixtures. Frakking fixtures!
  #
  # TODO, merge fixture data into test database, then build out sphinx
  # TODO, code some way to check if daemon is running.
  #
  #test "think_sphinx returns known location" do
  #  res = Location.search("MyString")
  #  # Hrmm, this will be tricky to test since we don't index 
  #  # the test db fixtures yet. Joy!
  #  assert_nil res.first
  #end
end
