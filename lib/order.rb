require_relative "customer.rb"

class Order
attr_reader :id
attr_accessor :products, :customer, :fulfillment_status

def initialize(id, products, customer, fulfillment_status = :pending)
  @id = id
  @products = products
  @customer = customer
  @fulfillment_status = fulfillment_status

  case status
  when @fulfillment_status != :pending, :paid, :processing, :shipped, :complete
    raise ArgumentError, "Please enter a valid fulfillment status"
  end

end

def total
  ((@products.values.sum) * 1.075).round(2)
return total
end

def add_product(product_name, price)
  @products[product_name] = price

  if @products.include?(product_name)
    raise ArgumentError, "That item has already been added"
  end
  return @products
end


add_product("apple" => 2.2)
puts products
shop = Order.new(22, products, "amy", :pending)
puts shop
