require_relative 'lib/customer'
require 'Rake'

class Order
  attr_accessor = :products

  def initialize order_id
    @order_id = order_id.to_i
  end

  def products(given_hash) 
    @products = given_hash
  end

  def customer
    #an instance of customer, the person who placed the order
  end
  
  def fulfillment_status(pending: "Pending", :paid, :processing, :shipped, :complete)
    #will determine the status of shipment
    # raise an exception if status doesnt match one of the above
  end

  def total
    # sums up the products
    # includes 7.5% sales tax
    # rounds the result to two decimal places
  end

  def add_product(#has two parameters)
    # if a product with the same name has been added, it raises and exception
  end
end

Tatiana = Order.new(003, "Tatiana")
puts Tatiana.products