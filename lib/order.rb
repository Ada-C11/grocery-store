require 'csv'
require 'awesome_print'
require_relative 'customer.rb'

class Order
  attr_reader :id
  attr_accessor :products, :customer, :fulfillment_status

  def initialize(id, products, customer, fulfillment_status = :pending)

    @id = id.to_i
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

  # creates a hash of the products and prices from the order of products
  def self.ordering(order)
      products = order[1].split(";")
      products_hash = {}
      products.each do |key|
        products_list = key.split(":")
        products_hash[products_list[0]] = products_list[1].to_f
    end
    return products_hash
  end

  # reads order file and creates instances of the orders
  def self.all
    return CSV.read("/Users/ranuseh/workspace/ada/ada_program/grocery-store/data/orders.csv").map do  |order|
      id = order.first # returns first index
      fulfillment_status = order.last # returns last index
      customer = Customer.find(order[-2].to_i) # calls method which takes customer id and returns an instance of customer
      products_hash = self.ordering(order) # calls that method to return a hash of the products
      Order.new(id, products_hash, customer, fulfillment_status.to_sym)
    end
  end

  # returns an instance of Order where the value of the id field in the CSV matches the passed parameter
  def self.find(id)  
    order = Order.all.find { |order| order.id == id }
    return order
  end
end
