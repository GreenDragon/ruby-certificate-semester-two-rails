require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  fixtures :users

  def setup
    @request.session[:user_id] = users(:john).id
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create user" do
    assert_difference('User.count') do
      post :create, :user => { 
        :name => "Three", 
        :password => "secret", 
        :password_confirmation => "secret"
      }
    end

    assert_redirected_to :controller => "users"
  end

  test "should show user" do
    get :show, :id => users(:john).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => users(:john).id
    assert_response :success
  end

  test "should update user" do
    put :update, :id => users(:john).id, :user => { :name => "One Updated" }
    assert_redirected_to :controller => "users"
  end

  test "should destroy user" do
    assert_difference('User.count', -1) do
      delete :destroy, :id => users(:john).id
    end

    assert_redirected_to users_path
  end

  test "should not delete the last user" do
    assert_raise RuntimeError do
      @users = User.find(:all)
      for user in @users
        user.destroy
      end
    end
  end
end
