require_relative "customer"
require 'csv'

# create class for Order
class Order
  # create reader for id, products, customer and fulfillment_status
  attr_reader :id, :products, :customer, :fulfillment_status
  # initialize reader class and create instance variables
  def initialize(id, product_hash, customer, fulfillment_status = :pending )
    @id = id
    @products = product_hash
    @customer = customer
    @fulfillment_status = fulfillment_status
    # raise the argument error if status given is not one provided
    unless [:pending, :paid, :processing, :shipped, :complete ].include?(fulfillment_status)
      raise ArgumentError, "Invalid fulfillment status #{fulfillment_status}. Please try again."
      @fulfillment_status = fulfillment_status
    end
  end
  
