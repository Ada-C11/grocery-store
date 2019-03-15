require_relative "customer.rb"
require "csv"

class Order
  attr_accessor :products, :customer, :fulfillment_status
  attr_reader :id

  def initialize(id, products, customer, fulfillment_status = :pending)
    @id = id
    @products = products
    @customer = customer
    @fulfillment_status = fulfillment_status
    until [:pending, :paid, :processing, :shipped, :complete].include?(fulfillment_status)
      raise ArgumentError, "Please enter a valid status."
    end
  end

  def total
    array_of_prices = @products.map do |_, price|
      price
    end
    tax = array_of_prices.sum * 0.075
    return (array_of_prices.sum + tax).round(2)
  end

  def add_product(name, price)
    if @products.keys.include?(name.downcase)
      raise ArgumentError, "This product is already in your order."
    else
      @products[name] = price
    end
  end

  def remove_product(name, price)
    if !(@products.keys.include?(name.downcase))
      raise ArgumentError, "#{name} is not in your order."
    end
    @products.delete(name.downcase)
  end

  def self.hash(products)
    products_hash = {}
    split_products = products.split(";")
    split_products.each do |pair_product|
      split_products = pair_product.split(":")
      products_hash[split_products[0]] = split_products[1].to_f
    end
    return products_hash
  end

 
  def self.all
    order_info_array = CSV.open("data/orders.csv", "r").map do |order|
      Order.new(order[0].to_i, self.hash(order[1]), Customer.find(order[2].to_i), order[3].to_sym)
    end
    return order_info_array
  end
 
  def self.find(id)
    self.all.each do |search_order|
      if search_order.id == id
        return search_order
      end
    end
    return nil
  end
end
