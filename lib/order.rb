class Order
  attr_reader :id
  attr_accessor :products, :customer, :fulfillment_status

  def initialize(id, products, customer, fulfillment_status)
    @id = id
    @products = products
    @customer = customer
    @fulfillment_status = fulfillment_status
  end

  def total(products)
    return "\$%0.2f" % [products.sum * 1.074]
  end
end

order = Order.new("string1", "string2", "string3", "string4")
products = [3, 5, 6, 2, 4]

puts order.total(products)
