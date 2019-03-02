require 'csv'
require_relative 'customer'

class Order
  attr_reader :id
  attr_accessor :products, :customer, :fulfillment_status

  def initialize(id, products, customer, fulfillment_status = :pending)
    @id = id
    @products = products
    @customer = customer
    @fulfillment_status = fulfillment_status
    unless [:pending, :paid, :processing, :shipped, :complete].include?(@fulfillment_status)
      raise ArgumentError, "Not valid fulfillment status"
    end 
  end

  def total
    sum = @products.values.sum
    taxed_sum = sum + (sum * 0.075)
    return taxed_sum.round(2)
  end

  def add_product(product_name, price)
    raise ArgumentError, "This product has already been added" if @products.keys.include?(product_name)
    @products[product_name] = price
  end

  def self.all
    all_orders = []
    CSV.read("/Users/karlaguadron/Documents/ada/03_week/grocery-store/data/orders.csv").each do |order|
      product_array = order[1].split(';')
       new_array = 
        product_array.map do |product| 
          entry = product.split(':') 
          entry[1] = entry[1].to_f
          entry
        end
      product_hash = Hash[new_array]
      all_orders << Order.new(order[0].to_i, product_hash, Customer.find(order[2].to_i), order[3].to_sym)
    end
    return all_orders
  end

  def self.find(id)
    Order.all.each do |order|
      if order.id == id
        return order
      end
    end
    return nil
  end
end
