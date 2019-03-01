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
    # create method for total which uses sum enumerable and rounds two decical places
  def total
    ( @products.sum{ |product, price| price } * 1.075 ).round(2)
  end
    # create a method for add product which raises an argument error if the product is already included the order
  def add_product(product_name, price)
    if @products.has_key?(product_name)
      raise ArgumentError, 'Your order already contains this product!'
    end
    return @products.merge!(product_name => price)
  end
    # add a method to remove product from the order collection
  def remove_product(product_name)
    unless @products.has_key?(product_name)
      raise ArgumentError, 'Sorry, this product is not in your order!'
    end
    return @products.delete(product_name)
  end
  
  def self.all 
    CSV.open('data/customer.csv','r').each do |order_from_csv|
      orders = []
      orders[:id] = order_from_csv["id"]
      orders[:products] = order_from_csv["products"]
      orders[:customer] = order_from_csv["customer"]
      orders[:fulfillment_status] = order_from_csv["fulfillment_status"]
    end
    return orders
  end
end 
