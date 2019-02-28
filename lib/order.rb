require_relative "customer.rb"

class Order
attr_reader :id
attr_accessor :products, :customer, :fulfillment_status

def initialize(id, products, customer, fulfillment_status = :pending)
  @id = id
  @products = products
  @customer = customer

  case fulfillment_status
  when :pending, :paid, :processing, :shipped, :complete
    @fulfillment_status = fulfillment_status
  else
    raise ArgumentError, "Please enter a valid fulfillment status"
  end
end

def total
 total = ((@products.values.sum) * 1.075).round(2)
return total
end

def add_product(product_name, price)

  @products.key?(product_name) ? (raise ArgumentError, "That item has already been added") : @products.store(product_name, price)
  # @products.store(product_name, price)

  # if @products.key?(product_name)
  #   raise ArgumentError, "That item has already been added"
  end
end

