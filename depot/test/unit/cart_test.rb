require 'test_helper'

class CartTest < ActiveSupport::TestCase

  fixtures  :products

  def setup
    @cart = Cart.new
    @git_book = products(:git_book)
    @sudo_book = products(:sudo_book)
  end

  test "test add one product" do
    @cart.add_product @git_book
    assert_equal 1, @cart.items.length
    assert_equal 1, @cart.items[0].quantity
    assert_equal "Git up and Go!", @cart.items[0].title
    assert_equal 19.99, @cart.items[0].price
  end

  test "test alias add_product method" do
    @cart << @git_book
    assert_equal 1, @cart.items.length
  end

  test "test adding unique products" do
    @cart.add_product @git_book
    @cart.add_product @sudo_book
    assert_equal 2, @cart.items.size
    assert_equal @git_book.price + @sudo_book.price, @cart.total_price
  end

  test "test adding duplicate products" do
    @cart.add_product @git_book
    @cart.add_product @git_book
    assert_equal 2*@git_book.price, @cart.total_price
    assert_equal 1, @cart.items.size
    assert_equal 2, @cart.items[0].quantity
    assert_equal 2, @cart.total_items
  end

end
