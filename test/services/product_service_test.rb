require 'minitest/autorun'
require 'minitest/mock'
require_relative '../../app/services/product_service'

class TestProductService < Minitest::Test
  def setup
    @repo = Minitest::Mock.new
    @scheduler = Minitest::Mock.new
    @logger = Minitest::Mock.new
    @service = ProductService.new(@repo, @scheduler, @logger)
  end

  def test_create_product
    @scheduler.expect(:in, nil, ['5s'])
    @service.create_product(100)
    @scheduler.verify
  end

  def test_list_products
    @repo.expect(:all, [])
    @service.list_products
    @repo.verify
  end

  def test_find_product_found
    product = { id: 1, price: 100 }
    @repo.expect(:find, product, [1])
    found_product = @service.find_product(1)
    assert_equal product, found_product
    @repo.verify
  end

  def test_find_product_not_found
    @repo.expect(:find, nil, [1])
    assert_raises(RuntimeError) { @service.find_product(1) }
    @repo.verify
  end
end