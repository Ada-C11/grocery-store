require_relative "customer"

def string_to_hash(string)
  hash = {}
  array_of_kvpairs = string.split(";")
  array_of_kvpairs.each do |pair|
    pair_array = pair.split(":")
    hash[pair_array[0]] = pair_array[1].to_f
  end
  return hash
end

class Order
  attr_reader :id, :products, :customer, :fulfillment_status
  attr_writer :products, :customer, :fulfillment_status

  def initialize(id, products, customer, fulfillment_status = :pending)
    @id = id
    @products = products
    @customer = customer
    @fulfillment_status = fulfillment_status
    unless [:pending, :paid, :processing, :complete, :shipped].include?(@fulfillment_status)
      raise ArgumentError, "Status not found"
    end
  end

  def total
    return (@products.values.sum * 1.075).round(2)
  end

  def add_product(product_name, price)
    if @products.keys.include?(product_name)
      raise ArgumentError, "Product already exists in order"
    end
    @products[product_name] = price
  end

  def self.all
    @array_of_orders = []
    CSV.open("data/orders.csv", headers: true).each do |order|
      order_hash = order.to_hash
      id = order_hash["id"].to_i
      products = string_to_hash(order_hash["products"])
      customer = Customer.find(order_hash["customer"].to_i)
      status = order_hash["status"].to_sym
      @array_of_orders.push(self.new(id, products, customer, status))
    end
    return @array_of_orders
  end

  def self.find(id)
    found_order = self.all.find do |order|
      order.id == id
    end
    return found_order
  end
end
