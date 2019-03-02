require "csv"
require "awesome_print"

class Order
  attr_reader :id
  attr_accessor :products, :fulfillment_status, :customer

  def initialize(id, products, customer, fulfillment_status = :pending)
    @id = id
    @products = products
    @customer = customer
    @fulfillment_status = fulfillment_status
    #raise ArgumentError.new("This is not a valid fulfillment status")

    valid_statuses = [:pending, :paid, :processing, :shipped, :complete]
    if valid_statuses.include?(@fulfillment_status) != true
      raise ArgumentError, "Invalid fullfilment status"
    end
  end

  def total
    total = @products.values.sum
    total = (total + (total * 7.5) / 100).round(2)
  end

  def add_product(name, price)
    if @products.has_key?(name)
      raise ArgumentError, "This product is already exist!"
    else
      @products[name] = price
    end
  end

  def remove_product(name)
    @products.delete_if { |product| product[:key] == name }
  end

  def self.all
    orders = []
    CSV.read("data/orders.csv").each do |line|
      id = line[0].to_i
      products = {}

      products_array = line[1].split(";")
      products_array.each do |p|
        product = p.split(":")
        products[product[0]] = product[1].to_f.round(2)
      end
      customer = Customer.find(line[2].to_i)
      fulfillment_status = line[3].to_sym
      order = Order.new(id, products, customer, fulfillment_status)
      orders << order
    end
    return orders
  end

  def self.find(id)
    self.all.each do |item|
      if item[0] == "#{id}"
        return item
      end
    end
    raise ArgumentError, "This order is not in the list."
  end
end

#ap Order.all
#ap Order.sort_order
#ap Order.all
