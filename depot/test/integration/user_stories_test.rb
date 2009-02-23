require 'test_helper'

class UserStoriesTest < ActionController::IntegrationTest
  fixtures :products

  test "buying one book" do
    LineItem.delete_all
    Order.delete_all
    git_book = products(:git_book)

    get "/store/index"
    assert_response :success
    assert_template "index"

    xml_http_request :put, "/store/add_to_cart", :id => git_book.id
    assert_response :success

    cart = session[:cart]
    assert_equal 1, cart.items.size
    assert_equal git_book, cart.items[0].product

    post "/store/checkout"
    assert_response :success
    assert_template "checkout"

    post_via_redirect "/store/save_order",
                      :order =>   { :name     => "John Howe",
                                    :address  => "123 Some St.",
                                    :email    => "john@howe.net",
                                    :pay_type => "check" }
    assert_response :success
    assert_template "index"
    assert_equal 0, session[:cart].items.size

    orders = Order.find(:all)
    assert_equal 1, orders.size
    order = orders[0]

    assert_equal "John Howe",     order.name
    assert_equal "123 Some St.",  order.address
    assert_equal "john@howe.net", order.email
    assert_equal "check",         order.pay_type

    assert_equal 1, order.line_items.size
    line_item = order.line_items[0]
    assert_equal git_book, line_item.product
  end
end
