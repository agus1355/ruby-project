# app/repositories/in_memory_product_repository.rb
class InMemoryProductRepository
  def initialize
    @products = {}
    @next_id = 1
  end

  # Crea un producto nuevo y lo guarda en memoria
  def create(price)
    id = @next_id
    product = { id: id, price: price }
    @products[id] = product
    @next_id += 1
    product
  end

  # Busca un producto por ID
  def find(id)
    @products[id]
  end

  # Devuelve todos los productos
  def all
    @products.values
  end

  # Elimina un producto por ID (opcional)
  def delete(id)
    @products.delete(id)
  end
end
