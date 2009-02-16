require 'test_helper'

class StoreControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:products)

    Product.find_products_for_sale.each do |product|
      assert_tag :tag => 'h3', :content => product.title
      assert_match /#{sprintf("%01.2f", product.price )}/, @response.body
    end
  end

  test "should have a cart instance" do
    get :index
    assert session[:cart]
  end

  test "should be able to add to cart" do
    get :index
    assert cart = session[:cart]
    assert_equal 0, cart.items.length
    xhr :post, :add_to_cart, { :id => products(:git_book).id}
    assert_response :success
    assert_equal 1, cart.items.length
  end

  test "should complain if bad product" do
    get :index
    assert_cart = session[:cart]
    xhr :post, :add_to_cart, { :id => "garbage" }
    assert_response :redirect
    assert_redirected_to :action => :index
    assert_equal "Invalid product", flash[:notice]
  end

  test "should be able to check out" do
    #xhr :post, :add_to_cart, { :id => products(:git_book).id}
    #assert_response :success
    get :empty_cart
    get :checkout
    assert_redirected_to :controller => "store", :action => "index"
    assert_equal "Your cart is empty", flash[:notice]
  end

  test "should redirect if cart is emtpy" do
    get :empty_cart
    assert_response :redirect
    get :checkout
    assert_redirected_to :action => :index
  end

  test "should be able to save order" do
    get :empty_cart
    assert_response :redirect
    xhr :post, :add_to_cart, { :id => products(:git_book).id}
    assert_response :success
    # ugh not pretty! but it works
    xhr :post, :save_order, { :order => { 
      :name       => orders(:one).name,
      :address    => orders(:one).address,
      :email      => orders(:one).email,
      :pay_type   => orders(:one).pay_type}
    }
    assert_response :redirect
    assert_redirected_to :action => :index
    assert_nil session[:cart]
    assert_equal "Thank you for your order", flash[:notice]
  end

  test "save order empties cart and redirect to index with status message" do
    @request.session[:cart] = Cart.new
    @request.session[:cart].add_product(products(:git_book))

    post :save_order, :order => {
      :name       => "Jo Blow",
      :address    => "123 Some St., Seattle, WA, 98101",
      :email      => "jo@blow.com",
      :pay_type   => "cc",
    }
    assert_nil session[:cart]
    assert_redirected_to :controller => :store, :action => :index
  end

  test "should empty cart" do
    get :empty_cart

    assert_response :redirect
    assert_nil assigns(:cart)
    assert_redirected_to :action => :index
  end
end
