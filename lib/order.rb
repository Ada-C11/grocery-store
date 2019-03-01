class Order
  attr_accessor :products, :customer, :fulfillment_status
  attr_reader :id

  def initialize(id, products, customer, fulfillment_status = :pending)
    @id = id
    @products = products
    @customer = customer
    @fulfillment_status = fulfillment_status
    fs_types = %i[pending paid processing shipped complete]
    raise ArgumentError, 'Wrong status' if fs_types.none? @fulfillment_status
  end

  def total(products)
    (products.values.sum * 1.075).round(2)
  end

  def add_product(name, price)
    raise ArgumentError if product.key?(name)

    products[name] = price
  end
end
