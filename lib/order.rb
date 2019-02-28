require "csv"

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
      id = line[0]
      products = line[1]
      customer = Customer.find(line[2])
      fulfillment_status = line[3]
      orders_all << self.new(id, products, customer, fulfillment_status)
    end
    orders_all
  end
end
