require "customer"

class Order
  attr_reader :id
  attr_accessor :products, :customer, :fulfillment_status

  def initialize(id, products, customer, fulfillment_status = :pending)
    @id = id
    @products = products
    @customer = customer

    fulfillment_options = [:pending, :paid, :processing, :shipped, :complete]
    unless fulfillment_options.include? fulfillment_status
      raise ArgumentError, "You entered a bogus status for fulfillment!"
    end
    @fulfillment_status = fulfillment_status
  end

  def total
    pre_tax = 0.0
    if @products != nil
      @products.each do |name, cost|
        pre_tax += cost
      end

      pre_tax += pre_tax * 0.075
      total_cost = format("%.2f", pre_tax).to_f
    else
      total_cost = 0
    end

    return total_cost
  end

  def add_product(product_name, price)
    if @products.keys.include? product_name
      raise ArgumentError, "This item already exists!"
    else
      @products[product_name] = price
    end
  end
end
