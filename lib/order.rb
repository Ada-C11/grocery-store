require "csv"
require_relative "customer.rb"

class Order
  attr_reader :id
  attr_accessor :customer, :products, :fulfillment_status

  OK_STATUS = [:pending, :paid, :processing, :shipped, :complete]

  def initialize(id_num, products, customer, fulfillment_status = :pending)
    @id = id_num
    @products = products
    @customer = customer
    raise ArgumentError, "invalid status" if OK_STATUS.include?(fulfillment_status) == false
    @fulfillment_status = fulfillment_status
  end

  def total()
    sum = 0
    @products.each do |item, price|
      sum += price
    end
    # Summing up the products
    sum = sum * 1.075
    # Adding a 7.5% tax
    return sum.round(2)
    # Rounding the result to two decimal places
  end

  def add_product(name, price)
    # If a product with the same name has already been added to the order, an ArgumentError should be raised
    raise ArgumentError, "product already here" if @products.has_key?(name)
    @products[name] = price
  end

  def remove_product(name)
    raise ArgumentError if @products.has_key?(name) == false
    @products.delete(name)
  end

  def self.all
    # returns a collection of Order instances, representing all of the Orders described in the CSV file
    order_array = []
    CSV.open("data/orders.csv", "r").each do |row|
      id = row[0].to_i
      products = {}
      row[1].split(";").each do |x|
        temp = x.split(":")
        products[temp[0]] = temp[1].to_f
      end
      customer = Customer.find(row[2].to_i)
      fulfillment_status = row[3].to_sym
      order_array << Order.new(id, products, customer, fulfillment_status)
    end
    return order_array
  end

  def self.find(id)
    # returns an instance of Order where the value of the id field in the CSV matches the passed parameter
    Order.all.detect { |order| order.id == id }
  end

  def Order.find_by_customer(customer_id)
    # returns a list of Order instances where the value of the customer's ID matches the passed parameter.
    Order.all.select { |order| order.customer.id == customer_id }
  end
end
