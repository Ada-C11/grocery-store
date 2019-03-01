require 'awesome_print'
require_relative '../lib/customer'


class Order
  attr_reader :id
  attr_accessor :products, :customer, :fulfillment_status

  def initialize(id, products, customer, fulfillment_status = :pending)
    @id = id
    @products = products
    @customer = customer
    valid_statuses = %i[pending paid processing shipped complete]
    if valid_statuses.include?(fulfillment_status)
      @fulfillment_status = fulfillment_status
    else
      raise ArgumentError
    end
  end

  def total
    total = (@products.values.sum * 1.075).round(2)
    return total
  end

  def add_product(name, price)
      @products.key?(name) ? (raise ArgumentError, "There is a duplicate item") : @products.store(name, price)
  end

  # Optional
  def remove_product(name)
    @products.delete_if {|k, v| k >= name}
  end

  def load_data(filename)
    # data = []
    # CSV.read('../data/orders.csv').each do |line|
    #   data << line.to_a
    # end
    # return data
  end  

  def self.all
    # Return collection of Order instances
    # represents all Orders in CSV
  end

  def self.find(id)
    # Returns instance of Order
    # id matches the passed param
    # should call order.all
  end

  # Optional
  def find_by_customer(customer_id)
    # Returns list of Order instances for matching cust ID
  end

  def save(filename)
    # outputs 
  end
end
