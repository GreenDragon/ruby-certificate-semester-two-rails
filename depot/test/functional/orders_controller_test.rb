require 'test_helper'

class OrdersControllerTest < ActionController::TestCase

  fixtures :users

  def setup
    @request.session[:user_id] = users(:john).id
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:orders)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create order" do
    assert_difference('Order.count') do
      post :create, :order => { 
        :name       => "John Doe",
        :address    => "123 Some St.",
        :email      => "jo@blow.net",
        :pay_type   => "po"
      }
    end

    assert_redirected_to order_path(assigns(:order))
  end

  test "should show order" do
    get :show, :id => orders(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => orders(:one).id
    assert_response :success
  end

  test "should update order" do
    put :update, :id => orders(:one).id, :order => { }
    assert_redirected_to order_path(assigns(:order))
  end

  test "should destroy order" do
    assert_difference('Order.count', -1) do
      delete :destroy, :id => orders(:one).id
    end

    assert_redirected_to orders_path
  end
end
