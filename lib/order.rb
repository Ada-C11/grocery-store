require_relative 'customer'
require 'Rake'
require 'awesome_print'

class Order
  attr_reader :order_id
  attr_accessor :products, :fulfillment_status

  def initialize order_id
    @order_id = order_id
    @products = {}
  end

  def products(given_hash) 
    @products = given_hash
  end

  def customer=(customer_info)
    @customer = customer_info
  end
  
  def fulfillment_status(status = :pending)
    if status == nil || status.class == Integer
      raise ArgumentError, "This is an invalid status"
    end

    case status
    when :pending
      @fulfillment_status = "Pending"
    when :paid
      @fulfillment_status = :paid
    when :processing
      @fulfillment_status = :processing
    when :shipped
      @fulfillment_status = :shipped
    when :complete
      @fulfillment_status = :complete
    when ""
      raise ArgumentError, "This is an invalid status"
    end
    if status == nil
    raise ArgumentError, "This is an invalid status"
    end
    return status
  end

  def total
    # sums up the products
    # includes 7.5% sales tax
    # rounds the result to two decimal places
  end

  def add_product #(has two parameters)
    # if a product with the same name has been added, it raises and exception
  end

end


tatiana = Order.new(1003)
puts tatiana.order_id
puts tatiana.fulfillment_status(:complete)