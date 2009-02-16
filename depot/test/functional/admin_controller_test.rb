require 'test_helper'

class AdminControllerTest < ActionController::TestCase
  test "should prompt for login" do
    get :index
    assert_redirected_to :controller => "admin", :action => "login"
  end

  test "valid user is logged in" do
    @request.session[:user_id] = users(:john).id
    get :index
    assert_response :success
  end

  test "valid user should be able to login" do
    xhr :post, :login, { :name => "john", :password => "secret" }
    assert_redirected_to :controller => "admin", :action => "index"
  end

  test "invalid user should not be able to login" do
    xhr :post, :login, { :name => "john", :password => "epicfail" }
    assert_equal "Invalid user/password combination", flash[:notice]
  end

  test "user should be able to logout" do
    get :logout
    assert_redirected_to :controller => "admin", :action => "login"
    assert_equal "Please log in", flash[:notice]
    assert_nil session[:user_id]
  end

  test "should be able to get list of total orders" do
    @request.session[:user_id] = users(:john).id
    get :index
    assert_match /We have 2 orders./, @response.body
  end
end
