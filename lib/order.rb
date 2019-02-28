

class Order
  attr_reader :id
  attr_accessor :products, :customer, :fulfillment_status

  def initialize(id, products, customer, fulfillment_status = :pending)
    if ![:pending, :paid, :processing, :shipped, :complete].include?(fulfillment_status)
      raise ArgumentError.new("#{fulfillment_status} not a valid fullfillment status")
    end
    @fulfillment_status = fulfillment_status
    @products = products
    @customer = customer
    @id = id
  end

  def total
    total_cost = products.sum do |name, cost|
      cost *= 1.075
    end
    return total_cost.round(2)
  end

  # An add_product method which will take in two parameters, product name
  # and price, and add the data to the product collection
  # If a product with the same name has already been added to the order, an ArgumentError should be raised

  def add_product(name, price)
    raise ArgumentError.new("#{name}\'s name is in use. ") if products[name]
    products[name] = price
  end
end
