require_relative "customer.rb"

class Order
  attr_reader :id
  attr_accessor :products, :customer, :fulfillment_status

  def initialize(id, products, customer, fulfillment_status = :pending)
    @id = id
    @products = products
    @customer = customer

    case fulfillment_status
    when :pending, :paid, :processing, :shipped, :complete
      @fulfillment_status = fulfillment_status
    else
      raise ArgumentError, "That is an invalid fulfillment status"
    end
  end

  def total
    (@products.values.sum * 1.075).round(2)
  end

  def add_product(product_name, price)
    if @products.include?(product_name)
      raise ArgumentError, "That is not a unique product"
    else
      @products[product_name] = price
    end
  end

  def remove_product(rem_product_name)
    if @products.include?(rem_product_name)
      @products.delete(rem_product_name)
    else
      raise ArgumentError, "That product is not available to be removed"
    end
  end

  # Products and prices are all one string in the CSV file, us .split method and split by ; and ; to split into an array with price and product, add those to a hash for products.
  def self.all
    order_array = []

    CSV.read("data/orders.csv", "r").each do |order_line|
      id = order_line[0].to_i
      products = {}
      order_line[1].split(";").each do |split_order_line|
        product_price_array = split_order_line.split(":")
        products[product_price_array[0]] = product_price_array[1].to_f
      end
      customer = Customer.find(order_line[2].to_i)
      fulfillment_status = order_line[3].to_sym
      instance_order = Order.new(id, products, customer, fulfillment_status)
      order_array << instance_order
    end
    return order_array
  end

  # Use find enumerable method to return customer if order.id == id, else returns nil.
  def self.find(id)
    Order.all.find do |order|
      order.id == id
    end
  end
end
