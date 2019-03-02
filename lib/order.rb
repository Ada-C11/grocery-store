require "pry"

require "csv"
require "customer"

class Order
  attr_reader :id, :fulfillment_status, :products, :customer

  def initialize(id, products, customer, fulfillment_status = :pending)
    @id = id
    @products = products
    @customer = customer
    fulfillment_status_options = [:pending, :paid, :processing, :shipped, :complete]
    if fulfillment_status_options.include?(fulfillment_status) == false
      raise ArgumentError, "Please put one of the options [:pending, :paid, :processing, :shipped, :complete] "
    end

    @fulfillment_status = fulfillment_status
  end

  def total
    sum = @products.values.sum
    sum_with_tax = (sum + sum * 0.075).round(2)
    return sum_with_tax
  end

  def add_product(name, price)
    if @products.keys.include?(name) == true
      raise ArgumentError, "This item is already listed!"
    else
      @products[name] = price
    end
  end

  def remove_product(name)
    if @products.keys.include?(name) == false
      raise ArgumentError, "This item is not included!"
    else
      @products.delete(name)
    end
  end

  def self.all
    orders = []
    CSV.read("data/orders.csv").each do |line|
      products = line[1].split(";")
      product_hash = {}
      products.each do |product|
        product = product.split(":")
        product_hash[product[0]] = product[1].to_f
      end
      new_order = Order.new(line[0].to_i, product_hash, Customer.find(line[2].to_i), line[3].to_sym)
      orders.push(new_order)
    end
    return orders
  end

  def self.find(id)
    orders = self.all
    found_order = (orders.select { |order| id == order.id })[0]
    return found_order
  end

  def self.find_by_customer(customer_id)
    orders = self.all
    # binding.pry

    found_customer = Customer.find(customer_id)
    # binding.pry
    found_orders = orders.select { |order| found_customer.id == order.customer.id }
    return found_orders
  end

  def self.save(filename)
    orders = self.all

    CSV.open(filename, "w") do |file|
      orders.each do |order|
        file << order
      end
    end
  end
end

puts Order.find_by_customer(25)
