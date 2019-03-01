require 'csv'
require 'awesome_print'
require_relative 'customer'

ORDER_FILEPATH = 'data/orders.csv'
# WAVE 2
class Order
  
  attr_reader :id
  attr_accessor :products, :customer, :fulfillment_status
  # Constructor
  def initialize(id, products, customer, fulfillment_status = :pending)
    # THIS WORKED BEFORE THE SELF.LOAD AND SELF.ALL METHODS WERE CREATED!
    if (fulfillment_status != :pending) && (fulfillment_status != :paid) && (fulfillment_status != :processing) && (fulfillment_status != :shipped) && (fulfillment_status != :complete)
      raise ArgumentError.new("This is not a real status")
    end
   
    if fulfillment_status == nil
      fulfillment_status = :pending
    end

    @id = id.to_i
    @products = products
    @customer = customer
    @fulfillment_status = fulfillment_status
  end

  # A total method which will calculate the total cost of the order by:
  #   Summing up the products
  #   Adding a 7.5% tax
  #   Rounding the result to two decimal places
  def total
    sum = 0
    taxed_sum = 0
    @products.each_value do |price|
      sum += price
      taxed_sum = sum + (sum * 0.075)
    end
    return taxed_sum.round(2)
  end

  # An add_product method which will take in two parameters, product name and price, and add the data to the product collection
  #   If a product with the same name has already been added to the order, an ArgumentError should be raised

  def add_product(name, price)
    if @products.include?(name)
      raise ArgumentError.new("A product with this name already exists")
    end
    @products[name] = price
  end

  def self.load(filepath)
    orders = Array.new

    puts filepath

    CSV.open(filepath, 'r').each do |csv_row|
      id = csv_row[0]
      products_arr = csv_row[1].split(";")
      products_hash = products_arr.map { |i| i.split ':'}.to_h
      products = products_hash.map { |k, v| [k.to_s, v.to_f] }.to_h
      customer = Customer.find(csv_row[2].to_i)
      fulfillment_status = csv_row[3]

      order = Order.new(id, products, customer, fulfillment_status.to_sym)
      orders.push(order)
    end 
    return orders
  end

  def self.all
    orders_data = Order.load(ORDER_FILEPATH)
    return orders_data
  end

  # returns an instance of Order where the value of the id field in the CSV matches the passed parameter
  def self.find(id)
    found_order = nil
    Order.all.each do |find_order|
      if find_order.id == id
        found_order = find_order
      end
    end
    return found_order
  end


end # class Order

puts "All orders:"
ap Order.all
puts "First order:"
ap Order.all.first
puts "Last order:"
ap Order.all.last
puts "Find order:"
puts Order.find(1)