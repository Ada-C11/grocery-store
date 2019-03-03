require "csv"

class Order
  attr_accessor :products, :customer, :fulfillment_status
  attr_reader :id

  def initialize(id, products, customer, fulfillment_status = :pending)
    # def initialize(id, products, customer, fulfillment_status: :pending)
    @id = id
    @products = products #hash
    @customer = customer
    @fulfillment_status = fulfillment_status
    until [:pending, :paid, :processing, :shipped, :complete].include?(fulfillment_status)
      raise ArgumentError, "Invalid fulfillment status"
    end
  end

  def total
    if products.length > 0
      sum = products.values.reduce(:+)
      tax = sum * 0.075
      total = sum + tax
      return total.round(2)
    else
      return 0
    end
  end

  def add_product(product_name, price)
    if products.include?(product_name)
      raise ArgumentError, "Product already exists"
    else
      products.merge!({product_name => price})
    end
  end

  def self.all
    # Return a collection of order instances (represents all the orders from the file)
    # 1,Lobster:17.18;Annatto seed:58.38;Camomile:83.21,25,complete
    # order ID -> Integer
    # Products -> String list of products foloowing the format name: price
    #       Make the list of products into a HASH -> Great piece to put into a helper method
    #       USE SPLIT IN HELPER METHOD :)
    #       Look into split method
    #       Use pry to prototype the logic?
    # Customer ID -> Integer after the products and before status
    # Status -> String fulfillment status is a symbol in the array -> [:pending, :paid, :processing, :shipped, :complete]
    @orders = []
    CSV.open("data/orders.csv", "r").each do |line|
      order_id = line[0]
      products_string = line[1]
      @products = products_split(products_string)
      customer = line[2]
      cus = Customer.find(customer)
      status = line[3]
      st = status.to_sym

      @orders << Order.new(order_id.to_i, @products, cus, st)
    end

    return @orders
  end

  def self.products_split(products)
    products_hash = {}
    array_products = products.split(";")
    array_products.each do |product|
      product_unit = product.split(":")
      hash = {product_unit[0] => (product_unit[1]).to_f}
      products_hash.merge! hash
    end
    return products_hash
  end

  # def self.find(id)
  #   # Return an instance of order when the id matches that given as a parameter
  #   orders = Order.all
  # end
  # Turn the customer ID into an instance of customer .... did you just write a method for this? invoke Customer.find?
end
