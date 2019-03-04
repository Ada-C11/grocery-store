require "pry"

class Order
  attr_reader :id
  attr_accessor :products, :customer, :fulfillment_status

  def initialize(id, products, customer, fulfillment_status = :pending)
    @id = id
    @products = products
    @customer = customer
    @fulfillment_status = fulfillment_status

    valid_fulfillment = [:pending, :paid, :processing, :shipped, :complete]

    if !(valid_fulfillment.include?(fulfillment_status))
      raise ArgumentError, "fulfillment status not valid "
    end
  end

  def total
    all_costs = products.values
    product_sum = 0
    all_costs.each do |cost|
      product_sum += cost
    end
    total_order_cost = ((7.5 * product_sum) / 100).to_f.round(2) + product_sum
    return total_order_cost
  end

  def add_product(product, price)
    if products[product] != nil
      raise ArgumentError, "There is already a product with the same name in the products hash"
    else
      products[product] = price
    end
    puts products
  end
end
