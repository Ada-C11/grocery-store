require 'csv'

require_relative 'customer'

class Order
  attr_reader :id, :products, :customer, :fulfillment_status

  def initialize(id, products, customer, fulfillment_status = :pending)
    @id = id
    @products = products
    @customer = customer

    valid_fulfillment_statuses = [:pending, :paid, :processing, :shipped, :complete]
    if valid_fulfillment_statuses.include? fulfillment_status
      @fulfillment_status = fulfillment_status
    else
      raise ArgumentError, "Fufillment status must be one of #{valid_fulfillment_statuses}; received #{fulfillment_status}"
    end
  end

  def total
    sum = @products.values.sum
    # sum = @products.sum{ |key, value| value }
    return (1.075 * sum).round(2)
  end

  def add_product(product_name, price)
    if @products.key?(product_name)
      raise ArgumentError, "#{product_name} already exists in product list."
    end
    @products[product_name] = price
  end

  def self.all
    orders = []
    headers = ['id', 'products', 'customer id', 'status']
    CSV.foreach("data/orders.csv", :headers => headers).each do |row|
      products = row['products'].split(";").map{ |key_value_pair|
        pair = key_value_pair.split(":")
        [pair[0], pair[1].to_f]
      }.to_h
      customer = Customer.find(row['customer id'].to_i)
      order = Order.new(row['id'].to_i, products, customer, row['status'].to_sym)
      orders << order
    end
    return orders
  end

  def self.find(id)
    self.all.find{|order| id == order.id}
  end

end
