class Order
  attr_reader :id
  attr_accessor :products, :customer, :fulfillment_status

  def initialize(id, products, customer, fulfillment_status = :pending)
    @id = id
    @products = products
    @customer = customer
    @fulfillment_status = fulfillment_status
    until [:pending, :paid, :processing, :shipped, :complete].include?(fulfillment_status)
      raise ArgumentError, "The status provided is invalid. Please enter a valid status:"
    end
  end

  def total
    order_total_with_tax = products.values.sum * 1.075
    return order_total_with_tax.floor(2)
  end

  def add_product(product_name, price)
    if products.keys.include?(product_name)
      raise ArgumentError, "the product is already exist in the system. Please enter another product or change the price of existing product"
    end
    products[product_name] = price
    return products
  end
end
