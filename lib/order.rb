require 'csv'
require_relative 'customer.rb'

class Order
  attr_reader :id
  attr_accessor :products, :fulfillment_status, :customer
  
  ORDER_ID_INDEX = 0
  PRODUCT_INDEX = 1
  CUSTOMER_ID_INDEX = 2
  FULFILLMENT_STATUS_INDEX = 3
  CSV_FILE_PATH = "/Users/elisepham/Ada/grocery-store/data/orders.csv"

  def initialize(id, products, customer, fulfillment_status = :pending)
    @id = id
    @products = products
    @fulfillment_status = fulfillment_status
    @customer = customer

    statuses = [:pending, :paid, :processing, :shipped, :complete]
    if !statuses.include?(fulfillment_status)
      raise ArgumentError.new("Invalid fulfillment status.")
    end
  end

  def total
    tax_rate = 7.5 / 100.0 
    return (@products.values.sum * (1.0 + tax_rate)).round(2)
  end

  def add_product(name, price)
    if @products.has_key?(name.downcase)
      raise ArgumentError.new("Product name already existed")
    end
    @products[name.downcase] = price
  end

  def remove_product(name)
    if !@products.has_key?(name.downcase)
      raise ArgumentError.new("The product you want to remove does not exist")
    end

    @products.delete(name.downcase)
  end

  def self.all
    orders = []
    CSV.open(CSV_FILE_PATH, 'r').each do |row|
      array = row[PRODUCT_INDEX].split /:|;/
      products = Hash.new

      (0...array.length - 1).step(2) do |i|
        products[array[i]] = array[i + 1].to_f.round(2)
      end

      order = Order.new(
        row[ORDER_ID_INDEX].to_i, products,
        Customer.find(row[CUSTOMER_ID_INDEX].to_i), 
        row[FULFILLMENT_STATUS_INDEX].to_sym)
      orders << order
    end
    return orders
  end

  def self.find(id)
    orders = Order.all
    orders.each do |order|
      if order.id == id
        return order
      end
    end
    return nil
  end

  def self.find_by_customer(customer_id)
    orders = Order.all
    result = Array.new
    orders.each do |order|
      if order.customer.id == customer_id
        result << order
      end
    end
    return result
  end
    
  def self.save(file_name)
    orders = Order.all
    CSV.open(file_name, "wb") do |csv|
      orders.each do |order|
        result = ""
        order.products.each_pair do |product, price|
          result += "#{product}:#{price};"
        end
        csv << ["#{order.id}","#{result.chomp(";")}",
          "#{order.customer.id}","#{order.fulfillment_status}"]
      end
    end
  end
end