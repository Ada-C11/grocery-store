require_relative "customer"

class Order
  attr_accessor :products, :customer, :fulfillment_status
  attr_reader :id

  @@fulfillment_status_array = [:pending, :paid, :processing, :shipped, :complete]

  def initialize(id, products, customer, fulfillment_status = :pending)
    @id = id
    @products = products
    @customer = customer
    @fulfillment_status = fulfillment_status
    if !@@fulfillment_status_array.include?(@fulfillment_status)
      raise ArgumentError, "Invalid fulfillment_status"
    end
  end

  def total
    product_sum = 0 if products.length == 0
    product_sum = @products.sum { |product, price| price }
    price_with_tax = ((product_sum + product_sum * 0.075).round(2))
    return price_with_tax
  end

  def add_product(product_name, price)
    raise ArgumentError if @products.include?(product_name)
    @products[product_name] = price
  end

  def self.make_product_hash(csv_string)
    product_hash = {}
    csv_string.split(";").each do |item|
      product = item.split(":")
      product_hash[product[0]] = product[1].to_f
    end
    return product_hash
  end

  def self.all
    orders_array = []
    CSV.read("data/orders.csv").each do |row|
      product_hash = Order.make_product_hash(row[1])
      new_order = Order.new(row[0].to_i, product_hash, Customer.find(row[2].to_i), row[3].to_sym)
      orders_array << new_order
    end
    return orders_array
  end
end
