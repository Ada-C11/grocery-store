require 'csv'
require_relative 'customer.rb'

class Order 
  attr_reader :id
  attr_accessor :products, :fulfillment_status, :customer
  def initialize(id, products, customer, fulfillment_status = :pending)
    @id = id 
    @products = products
    @customer = customer 
    @fulfillment_status = fulfillment_status 
    raise ArgumentError.new("Fulfillment status must be one of these: pending, paid, processing, shipped, or complete") if ![:pending, :paid, :processing, :shipped, :complete].include? fulfillment_status 
  end

  def total 
    product_sum = 0
    order_total = 0
    @products.values.each do |cost|
      product_sum += cost
    end
    order_total = product_sum + (product_sum * 0.075)
    return order_total.round(2)
  end

  def add_product(product_name, product_price)
    if @products.keys.include?(product_name)
      raise ArgumentError.new("Product is already added")
    else
      @products[product_name] = product_price
    end
  end

  def remove_product(product_name)
    if !@products.keys.include?(product_name)
      raise ArgumentError.new("No product called #{product_name} was found.")
    else
      @products.delete(product_name)
    end
  end

  def self.all
    all_orders = []
    CSV.read("data/orders.csv").each do |orders_from_csv|
      id = orders_from_csv[0].to_i
      products = {}
      products_array = orders_from_csv[1].split(';')
      products_array.each do |prod|
        product = prod.split(':')
        products[product[0]] = product[1].to_f.round(2)
      end

      customer = Customer.find(orders_from_csv[2].to_i)
      fulfillment_status = orders_from_csv[3].to_sym
      
      order = Order.new(id, products, customer, fulfillment_status)
      all_orders << order
    end
    return all_orders
  end

  def self.find(id)
    all_orders = Order.all
    order = all_orders.find{|order| order.id == id}
    # raise ArgumentError.new("Order id doesn't exist.") if order.nil? 
    return order
  end

  def self.find_by_customer(id)
    all_orders = Order.all
    customer_orders = all_orders.find_all{|order| order.customer.id == id}
    raise ArgumentError.new("There is no order for a customer with ID: #{id}") if customer_orders.empty?
    return customer_orders
  end

  def self.save(filename)
    all_orders = Order.all
    CSV.open(filename, "a+") do |file|
      all_orders.each do |order|
        products_array = []
        order.products.each do |k,v|
          products_array << k + ":" + v.to_s
        end
        products = products_array.join(';')
        file << [order.id, products, order.customer.id, order.fulfillment_status.to_s]
      end
    end
  end
end
