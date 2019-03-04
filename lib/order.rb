require "pry"
require "csv"
require "awesome_print"
require_relative "../lib/customer"

class Order
  attr_reader :id
  attr_accessor :products, :customer, :fulfillment_status

  def initialize(id, products, customer, fulfillment_status = :pending)
    @id = id
    @products = products
    @customer = customer
    @fulfillment_status = fulfillment_status

    valid_fulfillment = [:pending, :paid, :processing, :shipped, :complete]

    if !(valid_fulfillment.include?(fulfillment_status))
      raise ArgumentError, "fulfillment status not valid "
    end
  end

  def total
    all_costs = products.values
    product_sum = 0
    all_costs.each do |cost|
      product_sum += cost
    end
    total_order_cost = ((7.5 * product_sum) / 100).to_f.round(2) + product_sum
    return total_order_cost
  end

  def add_product(product, price)
    if products[product] != nil
      raise ArgumentError, "There is already a product with the same name in the products hash"
    else
      products[product] = price
    end
    puts products
  end

  def self.make_hash(order_products)
    array = order_products.split(";")
    product_hash = {}

    array.each do |product|
      name_cost = product.split(":")
      product_hash[name_cost[0]] = name_cost[1].to_f
    end
    return product_hash
  end

  def self.all
    order_collection = []
    CSV.open("../data/orders.csv", "r").each do |row|
      id = row[0].to_i
      products = Order.make_hash(row[1])
      customer_id = Customer.find(row[2].to_i)
      fulfillment_status = row[3].to_sym
      order_collection << Order.new(id, products, customer_id, fulfillment_status)
    end
    return order_collection
  end

  def self.find(id)
    Order.all.find do |order|
      order.id == id
    end
  end
end
