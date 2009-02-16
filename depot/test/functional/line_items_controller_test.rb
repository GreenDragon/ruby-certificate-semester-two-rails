require 'test_helper'

class LineItemsControllerTest < ActionController::TestCase

  fixtures :users

  def setup
    @request.session[:user_id] = users(:john).id
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:line_items)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create line_item" do
    assert_difference('LineItem.count') do
      post :create, :line_item => { 
        :product_id   => 1,
        :order_id     => 1,
        :quantity     => 1,
        :total_price  => 9.99
      }
    end

    assert_redirected_to line_item_path(assigns(:line_item))
  end

  test "should show line_item" do
    get :show, :id => line_items(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => line_items(:one).id
    assert_response :success
  end

  test "should update line_item" do
    put :update, :id => line_items(:one).id, :line_item => { }
    assert_redirected_to line_item_path(assigns(:line_item))
  end

  test "should destroy line_item" do
    assert_difference('LineItem.count', -1) do
      delete :destroy, :id => line_items(:one).id
    end

    assert_redirected_to line_items_path
  end

  test "test from cart item" do
    cart_item = CartItem.new(products(:git_book))
    line_item = LineItem.from_cart_item(cart_item)

    assert_equal products(:git_book), line_item.product
    assert_equal 1, line_item.quantity
    assert_equal products(:git_book).price, line_item.total_price
  end

  test "test from cart item with many of the same products" do
    product = products(:git_book)

    cart_item = CartItem.new(product)
    cart_item.increment_quantity

    line_item = LineItem.from_cart_item(cart_item)

    assert_equal product, line_item.product
    assert_equal 2, line_item.quantity
    assert_equal cart_item.price, line_item.total_price
  end

  test "test line item can has order" do
    line_item = line_items(:one)
    line_item.order = orders(:two)
    line_item.save!
    # asset_equal(:one) assert what?
  end
end
