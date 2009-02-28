require 'test_helper'

class GroupTest < ActiveSupport::TestCase
  def assert_save_failure(group)
    assert_raise ActiveRecord::RecordInvalid do
      group.save!
    end
  end

  test "group is invalid when missing name" do
    group = Group.create( {
      :alternate_name => "chirb",
      :url            => "http://chirb.org/"
    } )
    assert group.errors.on(:name)
    assert_save_failure(group)
  end

  test "group is invalid when missing url" do
    group = Group.create( {
      :name           => "Chicago Area Ruby Group",
      :alternate_name => "chirb"
    } )
    assert group.errors.on(:url)
    assert_save_failure(group)
  end

  test "group is invalid when url is invalid" do
    group = Group.create( { :url => "chirb" } )
    assert group.errors.on(:url)
    group = Group.create( { :url => "ftp://localhost/" } )
    assert group.errors.on(:url)
    group = Group.create( { :url => "httpq://localhost/" } )
    assert group.errors.on(:url)
    group = Group.create( { :url => "http://localhost/" } )
    assert ! group.errors.on(:url)
    group = Group.create( { :url => "https://localhost/" } )
    assert ! group.errors.on(:url)
  end

  test "group should be sorted by name" do
    group_ids = Group.sort_by_name.map { |g| g.id }
    assert_equal [1, 2, 3], group_ids
  end

  test "group should be sorted by location" do
    group_ids = Group.sort_by_location.map { |g| g.id }
    assert_equal [3, 2, 1], group_ids
  end
end
