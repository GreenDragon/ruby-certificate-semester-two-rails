require 'test_helper'

class OrderTest < ActiveSupport::TestCase

  # including this fixture broke shit in evil ways
  # fixtures :order
  # maybe this? :orders
  # arg! seems like an evil mix between test data in db and fixtures, wtf?
  fixtures :products

  def setup
    @order = Order.find(:first)
  end

  test "order has name" do
    @order.name = "Jo Blow"
    @order.save!
    assert_equal "Jo Blow", @order.name
  end

  test "order has address" do
    @order.address = "123 Jump Street"
    @order.save!
    assert_equal "123 Jump Street", @order.address
  end

  test "order has e-mail" do
    @order.email = "jo@blow.net"
    @order.save!
    assert_equal "jo@blow.net", @order.email
  end

  test "order has pay_type" do
    @order.pay_type = "po"
    @order.save!
    assert_equal "po", @order.pay_type
  end
  
  # garr! issues with fixtures

  test "add line items from cart" do
    order = Order.new
    cart = Cart.new
    cart.add_product(products(:git_book))
    line_items = order.add_line_items_from_cart(cart) 
    assert_equal 1, line_items[0].product.id
    assert_equal "Git up and Go!", line_items[0].product.title
  end
end
