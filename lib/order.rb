require "csv"
require "awesome_print"
require_relative "customer"

# class that creates an instance of an order
class Order

  # creates methods that will allow reading or writing of specified instance variables
  attr_reader :id, :products, :customer, :fulfillment_status
  attr_writer :fulfillment_status

  # constructor that sets up each instance of an order's id, products, customer, and fulfillment
  # status. Raises an ArgumentError if fulfillment entered is not a valid option
  def initialize(id, products, customer, fulfillment_status = :pending)
    @id = id
    @products = products
    @customer = customer
    @fulfillment_status = fulfillment_status
    unless [:pending, :paid, :processing, :shipped, :complete].include?(@fulfillment_status)
      raise ArgumentError, "Fulfillment status must be :pending, :paid, :processing, :shipped, :complete!"
    end
  end

  # method that returns a hash containing the id, products, customer, and fulfillment status for an order
  def new_order
    order_hash = {
      id: @id,
      products: @products,
      customer: @customer,
      fulfillment_status: @fulfillment_status,
    }
    return order_hash
  end

  # method that returns the total value, plus 7.5% tax of all products in an order
  def total
    return @products.sum { |product, value| ("%.2f" % (value * 1.075)).to_f }
  end

  # method that adds a product and price to the existing products hash of an order
  def add_product(product_name, price)
    if @products.keys.include?(product_name)
      raise ArgumentError, "A product with this name has already been added to the order!"
    end

    @products[product_name] = price
  end

  # method that returns an array of all order instances using data pulled from the orders.csv file
  def self.all
    all_orders = []

    CSV.open("data/orders.csv", "r").each do |line|
      products_array = line[1].split(/[;:]/)
      products_hash = Hash[*products_array]

      all_orders << Order.new(line[0].to_i, products_hash, Customer.find(line[2]), line[3].to_sym)
    end

    return all_orders
  end

  # method that returns an instance of an order where the value of the id field in the CSV
  # matches the passed parameter
  def self.find(id)
    found_order = Order.all.find { |order| id == order.id }

    if found_order == nil
      raise ArgumentError, "ID number does not exist!"
    else
      return found_order
    end

    # why you no work ternary??
    # found_order == nil ? raise ArgumentError, "ID number does not exist." : return found_order
  end
  # def self.find(id)
  #   Order.all.each do |order|
  #     return order if order.id == id
  #   end
  # end
end
