require 'test_helper'

class GroupsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:groups)
    # Hrmm, how do I stub this?
    # assert_not_nil session[geo_location]
  end

  test "should get index sorted by name" do
    get :index, :sort => "name"
    assert_response :success
    assert_not_nil assigns(:groups)
  end

  test "should get index search by seattle" do
    get :index, :q => "seattle"
    assert_response :success
    assert_not_nil assigns(:groups)
  end

  test "should get index search by seattle sort by name" do
    get :index, :q => "seattle", :sort => "name"
    assert_response :success
    assert_not_nil assigns(:groups)
  end

  test "should get index search by seattle sort by location" do
    get :index, :q => "seattle", :sort => "location"
    assert_response :success
    assert_not_nil assigns(:groups)
  end

  test "should get index sorted by location" do
    get :index, :sort => "location"
    assert_response :success
    assert_not_nil assigns(:groups)
  end

  test "should get new" do
    get :new
    assert_response :success
    assert_tag :tag => 'input', :attributes => {
      :name => 'group[name]'
    }
    assert_tag :tag => 'textarea', :attributes => {
      :name => 'group[description]'
    }
    assert_tag :tag => 'input', :attributes => {
      :name => 'group[url]'
    }
  end

  test "should create group" do
    assert_difference('Group.count') do
      post :create, :group => { :name => "Test Group", :url => "http://x.com" }
    end

    assert_redirected_to group_path(assigns(:group))
  end

  test "should show group" do
    get :show, :id => groups(:one).id
    assert_response :success
    assert_match /#{groups(:one).name}/, @response.body
    assert_match /#{groups(:one).description}/, @response.body
    assert_match /#{groups(:one).url}/, @response.body
  end

  test "should get edit" do
    get :edit, :id => groups(:one).id
    assert_response :success
    assert_tag :tag => 'input', :attributes => {
      :name => 'group[name]'
    }
    assert_match /#{groups(:one).name}/, @response.body
    assert_tag :tag => 'textarea', :attributes => {
      :name => 'group[description]'
    }
    assert_match /#{groups(:one).description}/, @response.body
    assert_tag :tag => 'input', :attributes => {
      :name => 'group[url]'
    }
    assert_match /#{groups(:one).url}/, @response.body
  end

  test "should update group" do
    put :update, :id => groups(:one).id, :group => { :url => "http://z.net" }
    assert_redirected_to group_path(assigns(:group))
  end

  test "should destroy group" do
    assert_difference('Group.count', -1) do
      delete :destroy, :id => groups(:one).id
    end

    assert_redirected_to groups_path
  end
end
