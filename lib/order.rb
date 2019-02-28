class Order
  attr_reader :id

  def initialize(id, products, customer, fulfillment_status: :pending)
    @id = id
    @products = products
    @customer = customer
    @fulfillment_status = fulfillment_status
  end

  def total
    subtotal = @products.values.sum
    total = (subtotal * 1.075).round(2)
    return total
  end
end
