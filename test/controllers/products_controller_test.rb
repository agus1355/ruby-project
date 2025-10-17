require 'minitest/autorun'
require 'minitest/mock'
require_relative '../../app/controllers/products_controller'

class TestProductController < Minitest::Test
  def setup
    @service = Minitest::Mock.new
    @controller = ProductController.new(@service)
  end

  def test_create
    @service.expect(:create_product, nil, [100])
    result = @controller.create({ price: 100 })
    assert_equal({ success: true, message: "Product will be created in 5 seconds" }, result)
    @service.verify
  end

  def test_index
    @service.expect(:list_products, [])
    result = @controller.index
    assert_equal({ success: true, products: [] }, result)
    @service.verify
  end

  def test_show_found
    product = { id: 1, price: 100 }
    @service.expect(:find_product, product, [1])
    result = @controller.show(1)
    assert_equal({ success: true, product: product }, result)
    @service.verify
  end

  def test_show_not_found
    @service.expect(:find_product, nil) { raise "Product not found" }
    result = @controller.show(1)
    assert_equal({ success: false, error: "Product not found" }, result)
    @service.verify
  end
end