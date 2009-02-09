require 'test_helper'
require 'bigdecimal'

class CartItemTest < ActiveSupport::TestCase

  fixtures  :products

  def setup
    @git_book = products(:git_book)
    @sudo_book = products(:sudo_book)
  end
  
  test "check title" do
    cart_item = CartItem.new(@git_book)
    assert_equal "Git up and Go!", cart_item.title
  end

  test "check price" do
    cart_item = CartItem.new(@sudo_book)
    assert_equal BigDecimal.new("29.99"), cart_item.price
  end

  test "check quantity" do
    cart_item = CartItem.new(@git_book)
    assert_equal 1, cart_item.quantity
  end

  test "increment quantity once" do
    cart_item = CartItem.new(@sudo_book)
    assert_equal 1, cart_item.quantity
    cart_item.increment_quantity
    assert_equal 2, cart_item.quantity
    assert_equal BigDecimal.new("59.98"), cart_item.price
  end

end
