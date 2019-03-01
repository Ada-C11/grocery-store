require_relative "customer"
require 'csv'

# create class for Order
class Order
  attr_reader :id, :products, :customer, :fulfillment_status

  def initialize(id, product_hash, customer, fulfillment_status = :pending )
    @id = id
    @products = product_hash
    @customer = customer 
    @fulfillment_status = fulfillment_status
    unless [:pending, :paid, :processing, :shipped, :complete ].include?(fulfillment_status)
      raise ArgumentError, "Invalid fulfillment status #{fulfillment_status}. Please try again."
      @fulfillment_status = fulfillment_status
    end
  end

  def total
    ( @products.sum{ |product, price| price } * 1.075 ).round(2)
  end

  def add_product(product_name, price)
    if @products.has_key?(product_name)
      raise ArgumentError, 'Your order already contains this product!'
    end
    return @products.merge!(product_name => price)
  end

  def remove_product(product_name)
    unless @products.has_key?(product_name)
      raise ArgumentError, 'Sorry, this product is not in your order!'
    end
    return @products.delete(product_name)
  end
  
  def self.all
  # iterate over each row of the csv
    total_orders = CSV.open('data/orders.csv','r').map do |field|
      Order.new(field[0].to_i, self.order_hash(field[1]), Customer.find(field[2].to_i), field[3].to_sym)
    end
    return total_orders
  end

  def self.order_hash(string)
    product_array = string.split(';') 
    product_hash = {}
    product_array.each do |c|
      key_value = c.split(':')
        product_hash[key_value[0]] = key_value[1].to_f
    end
    return product_hash
  end

  def self.find(id)
    total_orders = self.all
    total_orders.length.times do |i|
      if total_orders[i].id == id
        return total_orders[i]
      end
    end
    return nil
  end
end