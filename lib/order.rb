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

  def self.ordering(info) # Helper Method
    prices_list = info[1]
    products = prices_list.split(";")
    products_hash = {}
      parts = products[0].split(":")
      products_hash[parts[0]] = parts[1].to_f 
    return products_hash
  end

  def self.all
    all_order = []
    CSV.read("/Users/ranuseh/workspace/ada/ada_program/grocery-store/data/orders.csv").each do |order|
      id = order.first # returns first index
      fulfillment_status = order.last # returns last index
      customer_id = Customer.find(order[-2]) # turns customer id into an instance of customer
      product_hash = Order.ordering(order) # calls that method to return a hash of the products
      all_order.push(Order.new(id, product_hash, customer_id, fulfillment_status))
    end
    return all_order
  end

  print Order.all

  # def Order.find_by_customer(customer_id)
  #   order = Order.all.find { |order| order.id == id }
  #   return order
  # end

  # puts Order.find_by_customer(25)

end


