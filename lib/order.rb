require_relative "customer.rb"
require "orders.csv"

class Order
  attr_accessor :products, :customer, :fulfillment_status
  attr_reader :id

  def initialize(id, products, customer, fulfillment_status = :pending)
    @id = id
    @products = products
    @customer = customer
    @fulfillment_status = fulfillment_status
    until [:pending, :paid, :processing, :shipped, :complete].include?(fulfillment_status)
      raise ArgumentError, "please print a valid status"
    end
  end

  def total
    #total cost of order + 7.5% tax.round(2)
    array_of_prices = @products.map do |_, price|
      price
    end
    tax = array_of_prices.sum * 0.075
    return (array_of_prices.sum + tax).round(2)
  end

  def add_product(name, price)
    if @products.keys.include?(name)
      raise ArgumentError, "product is already present"
    else
      @products[name] = price
    end
  end
end
