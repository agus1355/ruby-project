class ProductService
  def initialize(product_repository,product_scheduler,logger)
    @repo = product_repository
    @scheduler = product_scheduler
    @logger = logger
  end

  def create_product(price)
    @scheduler.in '5s' do
      @repo.create(price)
      @logger.info "Producto created with price #{price} after 5 seconds"
    end
  end

  def list_products
    @repo.all
  end

  def find_product(id)
    product = @repo.find(id)
    if product.nil?
      raise "Product not found"
    else
      product
    end
  end
end
