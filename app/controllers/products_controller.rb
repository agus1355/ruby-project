class ProductController
  def initialize(product_service)
    @service = product_service
  end

  def create(params)
    price = params[:price]
    product = @service.create_product(price)
    { success: true, message: "Product will be created in 5 seconds" }
  end

  def index
    products = @service.list_products
    { success: true, products: products }
  end

  def show(id)
    begin
      product = @service.find_product(id)
    rescue => e
      return { success: false, error: e.message }
    else
      { success: true, product: product }
    end
  end
end
