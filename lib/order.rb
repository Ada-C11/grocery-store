require_relative 'customer.rb'
require 'csv'


class Order
  # read-only ID number
  attr_reader :id, :products, :customer, :fulfillment_status

  
  def initialize(id, products_hash, customer, fulfillment_status = :pending)
    @id = id
    @products = products_hash
    @customer = customer
    @fulfillment_status = fulfillment_status
   
    # raises ArgumentError if condition isn't met
    unless [:pending, :paid, :processing, :shipped, :complete].include?(fulfillment_status)
      raise ArgumentError, "Fulfillment status must be valid."
      @fulfillment_status = fulfillment_status
    end
  end

  # if hash has elements in it, calculate total. Else total = 0 
  def total
    if @products.length > 0
      expected_total = (@products.values.map.reduce(:+)) + (@products.values.map.reduce(:+) *(0.075)).round(2)
    else
      expected_total = 0
    end
      return expected_total
  end

  # add elements to the products hash
  def add_product(product_name, price)
    if @products.include?(product_name)
      raise ArgumentError, "This product already exists in the inventory."
    else
    end

    @products.store(product_name, price)
    return @products
  end
  # Optional method to remove product from list
  def remove_product(product_name)
    unless @products.include?(product_name)
      raise ArgumentError, "This product does not exist in the inventory"
    else 
      @products.delete(product_name)
    end
  end

  # helper method to split string into hash 
  def self.products_hash(string)
    products = {}
    product_thing = string.split(";")
    product_thing.each do |line|
      product_thing = line.split(':')
      products[product_thing[0]] = product_thing[1].to_f
    end
    return products
  end

  def self.all
    orders = CSV.open("data/orders.csv",'r').map do |row|
      Order.new(row[0].to_i, self.products_hash(row[1]), Customer.find(row[2].to_i), row[3].to_sym)
    end
    return orders
  end

  def self.find(id)
    self.all.each do |search|
      if search.id == id
        return search
      end
    end
    return nil
  end

  # couldn't get this optional to work. Find Order istance by Customer ID

  # def self.find_by_customer(customer_id)
  #   orders = []
  #   self.all.each do |search|
  #     if search.customer == Customer.find(20)
  #       orders << search
  #     end
  #     if orders.length > 0
  #       return orders
  #     else
  #       raise ArgumentError, "There are no Orders for this Customer ID."
  #     end
  #   end
  # end



end
