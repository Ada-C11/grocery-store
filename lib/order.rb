require 'pry'
class Order 
  attr_reader :id
  attr_accessor :products, :fulfillment_status, :customer
  def initialize(id, products, customer, fulfillment_status = :pending)
    @id =id 
    @products = products
    @customer = customer 
    @fulfillment_status = fulfillment_status 
    raise ArgumentError.new("Fulfillment status must be one of these: pending, paid, processing, shipped, or complete") if ![:pending, :paid, :processing, :shipped, :complete].include? fulfillment_status 
  end

  def total 
    product_sum = 0
    order_total = 0
    @products.values.each do |cost|
      product_sum += cost
    end
    order_total = product_sum + (product_sum * 0.075)
    return order_total.round(2)
  end

  def add_product(product_name, product_price)
    if @products.keys.include?(product_name)
      raise ArgumentError.new("Product is already added")
    else
      @products[product_name] = product_price
    end
  end

  def remove_product(product_name)
    if !@products.keys.include?(product_name)
      raise ArgumentError.new("No product called #{product_name} was found.")
    else
      @products.delete(product_name)
    end
  end
end
products = { "banana" => 1.99, "cracker" => 3.00 }

new_order = Order.new(1337, products, 'newcustomer', :pending)
new_order.remove_product("banana")
puts products
