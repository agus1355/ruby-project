require 'minitest/autorun'
require_relative '../../app/repositories/in_memory_product_repository'

class TestInMemoryProductRepository < Minitest::Test
  def setup
    @repo = InMemoryProductRepository.new
  end

  def test_create
    product = @repo.create(100)
    assert_equal 1, product[:id]
    assert_equal 100, product[:price]
  end

  def test_find
    product = @repo.create(100)
    found_product = @repo.find(product[:id])
    assert_equal product, found_product
  end

  def test_all
    @repo.create(100)
    @repo.create(200)
    products = @repo.all
    assert_equal 2, products.size
  end
end