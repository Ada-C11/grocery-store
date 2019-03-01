require_relative 'customer.rb'
require 'csv'


class Order
  # read-only ID number
  attr_reader :id, :products, :customer, :fulfillment_status

  # collection of products and their cost. given as a hash
  def initialize(id, products_hash, customer, fulfillment_status = :pending)
    @id = id
    @products = products_hash
    @customer = customer
    @fulfillment_status = fulfillment_status
   
    unless [:pending, :paid, :processing, :shipped, :complete].include?(fulfillment_status)
      raise ArgumentError, "Fulfillment status must be valid."
      @fulfillment_status = fulfillment_status
    end
  end

  def total
    if @products.length > 0
      expected_total = (@products.values.map.reduce(:+)) + (@products.values.map.reduce(:+) *(0.075)).round(2)
    else
      expected_total = 0
    end
      return expected_total
  end

  def add_product(product_name, price)
    if @products.include?(product_name)
      raise ArgumentError, "This product already exists in the inventory."
    else
    end

    @products.store(product_name, price)
    return @products
  end
  # Optional method to remove product from list
  def remove_product(product_name)
    unless @products.include?(product_name)
      raise ArgumentError, "This product does not exist in the inventory"
    else 
      @products.delete(product_name)
    end
  end

  #   # if product name already exists in hash, raise error
  # end


end


