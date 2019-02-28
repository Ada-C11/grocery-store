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
    
  end

  def add_product #(has two parameters)
    # if a product with the same name has been added, it raises and exception
  end

end

