require "csv"
require_relative "customer"

class Order
  attr_reader :id, :products, :customer, :fulfillment_status

  def initialize(id, products, customer, fulfillment_status = :pending)
    @id = id
    @products = products
    @customer = customer
    @fulfillment_status = fulfillment_status
    if (@fulfillment_status != :pending && @fulfillment_status != :shipped && @fulfillment_status != :paid && @fulfillment_status != :processing && @fulfillment_status != :complete)
      raise ArgumentError, "That is not a valid fulfillment status."
    end
  end

  def total
    sum = 0
    @products.each_value do |price|
      sum += price
    end
    sum_with_tax = sum + (sum * 0.075)
    return sum_with_tax.round(2)
  end

  def add_product(name, price)
    if @products.include?(name)
      raise ArgumentError, "This product has already been added to the order."
    end
    @products[name] = [price]
  end

  # optional method to remove product by name
  def remove_product(product_name)
    if @products.include?(product_name)
      @products.delete(product_name)
    else
      raise ArgumentError, "There is no product with that name."
    end
  end

  def self.parse_helper(product_string)
    array_strings = product_string.split(";")
    item_hash = Hash[array_strings.map { |item| item.split ":" }]
    item_hash.each do |key, value|
      item_hash[key] = value.to_f
    end
  end

  def self.all
    order_array = []

    CSV.open("data/orders.csv", "r").each do |line|
      new_order = Order.new(line[0].to_i, Order.parse_helper(line[1]), Customer.find(line[2].to_i), line[3].to_sym)
      order_array << new_order
    end
    return order_array
  end

  def self.find(id)
    Order.all.each do |order|
      if order.id == id
        return order
      end
    end
    return nil
  end
end
