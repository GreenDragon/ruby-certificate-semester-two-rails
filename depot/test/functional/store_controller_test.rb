require 'test_helper'

class StoreControllerTest < ActionController::TestCase
  #def setup
  #  session[:user_id] = 1
  #end
    
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
    # ajax madness!
    # assert_tag :tag => 'div', :attributes => { :class => 'cart-title' }
    # assert_tag :tag => 'td', :attributes => { :class => 'item-price' }
    # assert_tag :tag => 'td', :attributes => { :class => 'total-cell' }
  end

  test "should complain if bad product id" do
    get :index
    assert_cart = session[:cart]
    xhr :post, :add_to_cart, { :id => "garbage" }
    assert_response :redirect
    assert_redirected_to :action => :index
    assert_equal "Invalid product", flash[:notice]
  end

  test "should be able to check out" do
    xhr :post, :add_to_cart, { :id => products(:git_book).id}
    assert_response :success
    xhr :post, :checkout
    assert_response :success
    #assert_equal "Thank you for your order", flash[:notice]
    #assert_redirected_to :action => :index
    #assert_nil session[:cart]
    #assert_select_rjs(:update, 'notice')
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

  test "should empty cart" do
    get :empty_cart

    assert_response :redirect
    assert_nil assigns(:cart)
    assert_redirected_to :action => :index
  end



  # Shhh! it's private!
  #test "should redirect to index" do
  #  get :redirect_to_index
  #  assert_redirected_to :action => :index
  #end
end
