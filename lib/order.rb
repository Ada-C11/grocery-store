require_relative "customer.rb"
require "csv"

class Order
  attr_reader :id
  attr_accessor :products, :customer, :fulfillment_status

  def initialize(new_id, new_products, new_customer, new_fulfillment_status = :pending)
    @id = new_id
    @products = new_products
    @customer = new_customer

    case new_fulfillment_status
    when :pending, :paid, :processing, :shipped, :complete
      @fulfillment_status = new_fulfillment_status
    else
      raise ArgumentError, "Not a valid status."
    end
  end

  def total
    grocery_total = (@products.values.sum * 1.075).round(2)
    return grocery_total
  end

  def add_product(name, price)
    if @products.keys.include?(name) == true
      raise ArgumentError, "This product is already in the hash"
    else
      @products[name] = price
    end
  end

  #   def self.all
  #     CSV.open("data/orders.csv", "r").each do |instance|
  #         instance

  #   end
end
