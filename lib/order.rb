require 'csv'
require 'awesome_print'


class Order
  attr_reader :id
  attr_accessor :products, :customer, :fulfillment_status

  def initialize(id, products, customer, fulfillment_status = :pending)

    @id = id
    @products = products
    @customer = customer
    @fulfillment_status = fulfillment_status
    raise ArgumentError.new("Status not valid") unless fulfillment_status == :pending || fulfillment_status == :paid ||
     fulfillment_status == :processing || fulfillment_status == :shipped || fulfillment_status == :complete  
  end

  def total
    sum = 0
    @products.each_value do |price|
      sum += price
    end
    total = (sum * 0.075) + sum
    return total.round(2)
  end

  def add_product(product_name, product_price)
    raise ArgumentError.new("Product already exists") if @products.has_key? product_name  
    @products[product_name] = product_price
    return @products
  end
end

def Order.all
  return CSV.read("/Users/ranuseh/workspace/ada/ada_program/grocery-store/data/orders.csv").map do |order|
    product_id = order.first # returns first line
    fulfillment_status = order.last # returns last line
    customer_id = order[-2]
    puts customer_id
  end
  # Order.new(id, products, customer, fulfillment_status)
end

Order.all

address = [1,Lobster:17.18;Annatto seed:58.38;Camomile:83.21,25,complete]

def product_ordering(info)
  prices_list = info[1] #Grabbing prices from array
  puts prices_list
  # products = prices_list.split(";") #Splitting by products
  # products_hash = {}
  # products.each do |product|
  #   parts = product.split(":") # splitting by product name and price
  #   product_name = product[0]
  #   product_price = product[1]
  #   products_hash[product_name] = product_price
end# end

product_ordering(order.all)

# Parse the list of products into a hash
# This would be a great piece of logic to put into a helper method
# You might want to look into Ruby's split method
# We recommend manually copying the first product string from the CSV file and using pry to prototype this logic
# Turn the customer ID into an instance of Customer
# Didn't you just write a method to do this?