require_relative "customer"

class Order
  def initialize(id, products, customer, fulfillment_status = :pending)
    @id = id
    @products = products
    @customer = customer
    @fulfillment_status = fulfillment_status

    unless [:pending, :paid, :processing, :shipped, :complete].include?(@fulfillment_status)
      raise ArgumentError, "Invalid fulfillment status: #{@fulfillment_status}"
    end
  end

  attr_reader :id, :products, :customer

  attr_accessor :fulfillment_status

  def total
    # total is 0 if there's no product
    if @products.length == 0
      total = 0
    else # Sums up products
      total = @products.values.inject { |sum, cost| sum + cost }
      # Adds a 7.5% tax
      tax = total * 7.5 / 100
      total += tax
      # Rounds the result to two decimal places
      total = "%.2f" % total
    end
    # Returns total
    return total.to_f
  end

  def add_product(product_name, product_price)
    # Raises an argument if product already exists
    if @products.keys.include?(product_name)
      raise ArgumentError
    else # add data to product collection
      @products.store(product_name, product_price)
    end
  end

  def remove_product(product_name)
    unless @products.keys.include?(product_name)
      raise ArgumentError, "Product not found!"
    else
      @products.delete(product_name)
    end
  end

  def self.all
    orders = []
    file = CSV.open("data/orders.csv", "r")

    file.each do |line|
      order_id = line[0].to_i

      products = {}
      item_and_price = line[1].split(";")
      item_and_price.each do |item|
        temp_array = item.split(":")
        products.store(temp_array.first, temp_array.last.to_f)
      end

      customer_id = line[2].to_i
      customer = Customer.find(customer_id)

      fulfillment_status = line[3].to_sym

      order = Order.new(order_id, products, customer, fulfillment_status)
      orders << order
    end
    return orders
  end

  def self.find(id_number)
    Order.all.find do |order|
      order.id == id_number
      # Returns an instance of Order when the value of the id field
      # matches the passed parameter
    end
  end
end
