require 'test_helper'
require 'bigdecimal'

class LineItemTest < ActiveSupport::TestCase
  
  fixtures  :products

  def setup
    @git_book = products(:git_book)
  end

  test "from cart items" do
    cart_item = CartItem.new(@git_book)
    li = LineItem.from_cart_item(cart_item)
    assert_equal 1, li.product.id
    assert_equal 1, li.quantity
    assert_equal BigDecimal.new("19.99"), li.total_price
  end
end
