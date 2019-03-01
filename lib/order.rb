require_relative "customer"
require "pry"

class Order
  def initialize(id, products, customer, fulfillment_status = :pending)
    @id = id
    @products = products
    @customer = customer
    @fulfillment_status = fulfillment_status

    unless [:pending, :paid, :processing, :shipped, :complete].include?(@fulfillment_status)
      raise ArgumentError, "Invalid fulfillment status: #{@fulfillment_status}"
    end
  end

  attr_reader :id, :products, :customer

  attr_accessor :fulfillment_status

  def total
    if @products.length == 0
      total = 0
    else
      total = @products.values.inject { |sum, cost| sum + cost }
      tax = total * 7.5 / 100
      total += tax
      total = "%.2f" % total
    end

    return total.to_f
  end

  def add_product(product_name, product_price)
    if @products.keys.include?(product_name)
      raise ArgumentError, "Product already exists: #{product_name}"
    else
      @products.store(product_name, product_price)
    end
  end

  def remove_product(product_name)
    unless @products.keys.include?(product_name)
      raise ArgumentError, "Product not found!"
    else
      @products.delete(product_name)
    end
  end

  def self.separate_products(product_list)
    products = {}
    item_and_price = product_list.split(";")
    item_and_price.each do |item|
      temp_array = item.split(":")
      products.store(temp_array.first, temp_array.last.to_f)
    end

    return products
  end

  def self.all
    orders = []
    file = CSV.open("data/orders.csv", "r")

    file.each do |line|
      order_id = line[0].to_i

      products = self.separate_products(line[1])
      customer_id = line[2].to_i
      customer = Customer.find(customer_id)

      fulfillment_status = line[3].to_sym

      order = Order.new(order_id, products, customer, fulfillment_status)
      orders << order
    end
    return orders
  end

  def self.find(id_number)
    Order.all.find do |order|
      order.id == id_number
    end
  end

  # Optional
  def self.find_by_customer(customer_id)
    orders_by_customer = []
    Order.all.find_all do |order|
      if order.customer.id == customer_id
        orders_by_customer << order
      end
    end
    if orders_by_customer.length == 0
      return nil
    else
      return orders_by_customer
    end
  end
end
