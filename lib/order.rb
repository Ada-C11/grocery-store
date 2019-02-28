require_relative 'customer'
require 'Rake'
require 'awesome_print'

class Order
  attr_reader :id
  attr_accessor :products, :fulfillment_status, :customer, :products

  def initialize id, products, customer, fulfillment_status = :pending
    @id = id
    @fulfillment_status = fulfillment_status
    @customer = customer
    @products = products

    unless [:pending, :paid, :complete, :processing, :shipped].include?(fulfillment_status)
      raise ArgumentError, "This is an invalid status"
    end
  end

  def total
    pre_tax = 0
    @products.each do |key, value|
     pre_tax += value
    end
    total = (pre_tax * 0.075) + pre_tax
    return total.round(2) 
  end

  def add_product name, price
    if @products.has_key? name
      raise ArgumentError, "Cannot duplicate extant product"
    else
    @products[name] = price
    end
    return @products
  end
end
