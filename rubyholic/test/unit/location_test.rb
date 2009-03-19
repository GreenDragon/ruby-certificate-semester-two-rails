require 'test_helper'
require 'bigdecimal'

class LocationTest < ActiveSupport::TestCase
  context "A Location instance" do
    setup do
      @location = Location.find(:first)
    end

    should "return name of location" do
      assert_equal "Espresso Vivace Roasteria", @location.name
    end
  end
end

class LocationTest < ActiveSupport::TestCase
  def setup
    @spoof = Location.new
    @spoof.name      = "Floating Tea Leaves" 
    @spoof.address   = "1704 NW Market St., Seattle, WA"
    @spoof.latitude  = BigDecimal.new("47.66867")
    @spoof.longitude = BigDecimal.new("-122.3789849")
  end

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
        :name     => locations(:one).name, 
        :address  => locations(:one).address
      } )
    end
  end

  test "location is invalid when missing address" do
    location = Location.create( {
      :name     => "Missing Address"
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
        :address  => locations(:one).address
      } )
    end
  end

  test "providing a valid address generates good geocode result" do
    location = Location.create( { 
      :name     => "New Century Tea House",
      :address  => "416 Maynard Ave S, Seattle, WA, USA",
    } )
    assert_valid(location)
    #
    stub(Location).save! { @spoof }
    #
    location.save!
    assert_equal BigDecimal.new("47.5990131"),  location.latitude
    assert_equal BigDecimal.new("-122.325085"), location.longitude
  end

  test "setting an ambiguous address generates a geocode error" do
    location = Location.create( {
      :name     => "Chicago Bad House",
      :address  => "200 E. Randolph, 25th Floor, Chicago, IL, USA"
    } )
    assert location.errors.on(:address)
    assert_save_failure(location)
  end

  test "updating the location address and name triggers a new geocode lookup" do
    location = Location.find(locations(:one).id)
    loc_address = location.address.clone
    loc_name = location.name.clone
    #
    location.name = "Floating Tea Leaves"
    location.address = "1704 NW Market St., Seattle, WA"
    #
    stub(Location).save! { @spoof }
    #
    assert location.save!
    assert_equal "Floating Tea Leaves", location.name
    assert_equal BigDecimal.new("47.66867"),     location.latitude
    assert_equal BigDecimal.new("-122.3789849"), location.longitude
    #
    # rollback to known data so other unit tests don't blow up
    location.name = loc_name
    location.address = loc_address
    #
    stub(Location).save! { locations(:one) }
    #
    assert location.save!
    assert_equal locations(:one).name, location.name
    assert_equal locations(:one).latitude,  location.latitude
    assert_equal locations(:one).longitude, location.longitude
  end

  test "should find closest group location by address" do
    mock(Location).closest("Seattle, WA") { locations(:one) }
    location = Location.closest("Seattle, WA")
    assert_equal locations(:one).id, location.id
  end

  test "should find closest group location by zipcode" do
    mock(Location).closest("98144") { locations(:one) }
    location = Location.closest("98144")
    assert_equal locations(:one).id, location.id
  end

  test "should find closest location by address within given distance" do
    mock(Location).within(10, "Bellevue, WA") { [locations(:one)] }
    #flexmock(Location).should_receive(:within).once.with(10, "Bellevue, WA").and_return([locations(:one)])
    location = Location.within(10, "Bellevue, WA")
    assert_equal locations(:one).id, location[0].id
  end

  test "should raise error when results are ambiguous" do
    location = Location.new
    location.address = "532 E Broadway Ave., Seattle, WA, USA"
    assert !location.valid?
    assert location.errors.on(:address)
  end

  # How to start/stop rake ts:start/ts:stop from test suites?
  # Or sanity check that think_sphinx interface is running?
  # scan for pid? 
  #
  # More development db vs fixtures. Frakking fixtures!
  #
  # DONE, merge fixture data into test database
  # TODO, build out sphinx
  # TODO, code some way to check if daemon is running.
  #
  #test "think_sphinx returns known location" do
  #  res = Location.search("MyString")
  #  # Hrmm, this will be tricky to test since we don't index 
  #  # the test db fixtures yet. Joy!
  #  assert_nil res.first
  #end
end
