require 'test_helper'

class ProductsControllerTest < ActionController::TestCase
  
  fixtures :users

  def setup
    @request.session[:user_id] = users(:john).id
  end
  
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:products)
  end

  test "should display product" do
    get :show, :id => products(:git_book).id
    assert_response :success
    # too chatty
    # assert_tag :tag => 'strong', :content => 'Title:'
  end

  test "should get new" do
    get :new
    assert_response :success
    assert_tag :tag => 'input', :attributes => {
      :name => 'product[title]'
    }
    assert_tag :tag => 'textarea', :attributes => {
      :name => 'product[description]'
    }
    assert_tag :tag => 'input', :attributes => {
      :name => 'product[image_url]'
    }
    assert_tag :tag => 'input', :attributes => {
      :name => 'product[price]'
    }
  end

  test "should create product" do
    assert_difference('Product.count') do
      post :create, :product => {
        :title        => 'awesome product',
        :description  => 'awesome product description',
        :image_url    => 'http://example.com/foo.gif',
        :price        => '100'
      }
    end

    assert_redirected_to product_path(assigns(:product))
  end

  test "should show product" do
    get :show, :id => products(:git_book).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => products(:git_book).id
    assert_tag :tag => 'input', :attributes => {
      :name => 'product[title]'
    }
    assert_tag :tag => 'textarea', :attributes => {
      :name => 'product[description]'
    }
    assert_tag :tag => 'input', :attributes => {
      :name => 'product[image_url]'
    }
    assert_tag :tag => 'input', :attributes => {
      :name => 'product[price]'
    }
    assert_response :success
  end

  test "should update product" do
    put :update, :id => products(:git_book).id, :product => {
      :title => 'mega awesome title'
    }
    assert_redirected_to product_path(assigns(:product))

    assert_equal 'mega awesome title', Product.find(products(:git_book).id).title
  end

  test "should not update product with empty image_url" do
    put :update, :id => products(:git_book).id, :product => {
      :image_url => ''
    }
    assert_response :success
    assert_template 'edit'
  end

  test "should destroy product" do
    assert_difference('Product.count', -1) do
      delete :destroy, :id => products(:git_book).id
    end

    assert_redirected_to products_path
  end

  # more tests

  # would this be considered a unit test, or functional?

  test "should prevent duplicate titles" do
    post :create, :product => {
      :title        => 'awesome product',
      :description  => 'awesome product description',
      :image_url    => 'http://example.com/foo.gif',
      :price        => '100'
    }

    assert_redirected_to product_path(assigns(:product))

    # Dupe entry

    post :create, :product => {
      :title        => 'awesome product',
      :description  => 'awesome product description',
      :image_url    => 'http://example.com/foo.gif',
      :price        => '100'
    }

    assert_template "new"
    # assert_redirected_to :controller => 'product', :action => 'new'
  end
end
