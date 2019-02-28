require_relative "customer"

class Order
  attr_accessor :products, :customer, :fulfillment_status
  attr_reader :id

  @@fulfillment_status_array = [:pending, :paid, :processing, :shipped, :complete]

  def initialize(id, products, customer, fulfillment_status = :pending)
    @id = id
    @products = products
    @customer = customer
    @fulfillment_status = fulfillment_status
    if !@@fulfillment_status_array.include?(@fulfillment_status)
      raise ArgumentError, "Invalid fulfillment_status"
    end
  end

  def total
    product_sum = 0 if products.length == 0
    product_sum = @products.sum { |product, price| price }
    price_with_tax = ((product_sum + product_sum * 0.075).round(2))
    return price_with_tax
  end

  def add_product(product_name, price)
    raise ArgumentError if @products.include?(product_name)
    @products[product_name] = price
  end
end

# address = {
#   street: "123 Main",
#   city: "Seattle",
#   state: "WA",
#   zip: "98101",
# }
# customer = Customer.new(123, "a@a.co", address)
# id = 1337
# fulfillment_status = :shipped
# order = Order.new(id, {}, customer, fulfillment_status)
