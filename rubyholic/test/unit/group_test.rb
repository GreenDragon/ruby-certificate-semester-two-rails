require 'test_helper'

class GroupTest < ActiveSupport::TestCase
  def assert_save_failure(group)
    assert_raise ActiveRecord::RecordInvalid do
      group.save!
    end
  end

  test "group is invalid when missing name" do
    group = Group.create( {
      :description  => "chirb",
      :url          => "http://chirb.org/"
    } )
    assert group.errors.on(:name)
    assert_save_failure(group)
  end

  test "group is invalid when name is not unique" do
    assert_raises ActiveRecord::StatementInvalid do
      group = Group.create( { 
        :name => "Seattle.rb",
        :url  => "http://localhost/"
      } )
    end
  end

  test "group is invalid when missing url" do
    group = Group.create( {
      :name         => "LARuby",
      :description  => "Los Angeles Ruby Group"
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

  test "group index returns instance of WillPaginate::Collection" do
    group = Group.index(1)
    assert_equal WillPaginate::Collection, group.class
    assert_equal [1, 2, 3, 4, 5], group.map { |g| g.id}
  end
    

  test "group should be sorted by name" do
    group_ids = Group.sort("name", 1).map { |g| g.id }
    assert_equal [5, 4, 2, 1, 3], group_ids
  end

  test "group should be sorted by name with named_scope" do
    group_ids = Group.sort_by_name.map { |g| g.id }
    assert_equal [5, 4, 2, 1, 3], group_ids
  end

  test "group should be sorted by location" do
    group_ids = Group.sort("locations.name", 1).map { |g| g.id }
    assert_equal [2, 1, 4, 5, 3], group_ids
  end

  test "group should be sorted by location with named_scope" do
    group_ids = Group.sort_by_location.map { |g| g.id }
    assert_equal [2, 1, 4, 5, 3], group_ids
  end

  test "simple search should return primary group" do
    mock(Group).search("seattle") { [groups(:one)] }
    results = Group.search("seattle")
    assert_equal groups(:one).id, results[0].id
  end
end
