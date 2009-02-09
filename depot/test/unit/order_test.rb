require 'test_helper'

class OrderTest < ActiveSupport::TestCase

  # including this fixture broke shit in evil ways
  # fixtures :order
  # maybe this? :orders
  # arg! seems like an evil mix between test data in db and fixtures, wtf?

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

  #test "add line items from cart" do
  #  fail "write me"
  #end
end
