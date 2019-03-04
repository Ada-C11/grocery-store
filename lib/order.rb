require "csv"
require_relative "customer"

class Order
  attr_reader :id
  attr_accessor :products, :customer, :fulfillment_status

  def initialize(id, products, customer, fulfillment_status = :pending)
    if ![:pending, :paid, :processing, :shipped, :complete].include?(fulfillment_status)
      raise ArgumentError.new("#{fulfillment_status} not a valid fullfillment status")
    end
    @fulfillment_status = fulfillment_status
    @products = products
    @customer = customer
    @id = id
  end

  def total
    total_cost = products.sum do |name, cost|
      cost *= 1.075
    end
    return total_cost.round(2)
  end

  def add_product(name, price)
    raise ArgumentError.new("#{name}\'s name is in use. ") if products[name]
    products[name] = price
  end

  def self.all
    orders_all = []
    CSV.open("data/orders.csv", "r").each do |line|
      id = line[0].to_i
      products = helper_csv_hash(line[1])
      customer = Customer.find(line[2].to_i)
      fulfillment_status = line[3].to_sym
      orders_all << self.new(id, products, customer, fulfillment_status)
    end
    orders_all
  end

  def self.helper_csv_hash(string_hash)
    hash = {}
    while string_hash.index(":")
      product_end = string_hash.index(":") - 1
      cost_end = string_hash.index(";") ? string_hash.index(";") + 1 : -1
      hash[string_hash[0..product_end]] = string_hash[(product_end + 2)..cost_end].to_f
      string_hash = string_hash[cost_end..-1]
    end
    return hash
  end

  def self.find(id, orders = Order.all)
    return orders.find(ifnone = nil) do |order|
             order.id == id
           end
  end
end
