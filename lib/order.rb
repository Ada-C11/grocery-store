require_relative "customer.rb"
require "csv"

class Order
  attr_reader :id
  attr_accessor :products, :customer, :fulfillment_status

  def initialize(id, products, customer, fulfillment_status = :pending)
    @id = id
    @products = products
    @customer = customer

    case fulfillment_status
    when :pending, :paid, :processing, :shipped, :complete
      @fulfillment_status = fulfillment_status
    else
      raise ArgumentError, "Not a valid status."
    end
  end

  def total
    grocery_total = (@products.values.sum * 1.075).round(2)
    return grocery_total
  end

  def add_product(name, price)
    if @products.keys.include?(name) == true
      raise ArgumentError, "This product is already in the hash"
    else
      @products[name] = price
    end
  end

  def self.string_to_hash(string_products)
    array_string_products = string_products.split(";")
    # ap array_string_products

    product_hash = {}
    array_string_products.each do |products|
      product_string_split = products.split(":")
      product_hash[product_string_split[0]] = product_string_split[1].to_f
    end
    return product_hash
  end

  def self.all
    orders = []
    CSV.open("data/orders.csv", "r").each do |instance|
      instance

      id = instance[0].to_i
      products = self.string_to_hash(instance[1])
      customer = Customer.find(instance[2].to_i)
      fulfillment_status = instance[3].to_sym

      instance_order = Order.new(id, products, customer, fulfillment_status)

      orders << instance_order
    end
    # ap orders
    return orders
  end

  def self.find(id)
    self.all.each do |order|
      if order.id == id
        return order
      end
    end
    return nil
  end
end
