require "csv"
require "awesome_print"

class Order
  attr_reader :id
  attr_accessor :products

  def initialize(id, products, customer, fulfillment_status = :pending)
    @id = id
    @products = products
    @customer = customer
    @fulfillment_status = fulfillment_status

    def fulfillment_status
      valid_statuses = [:pending, :paid, :processing, :shipped, :complete]
      if valid_statuses.include?(@fulfillment_status) == true
        return @fulfillment_status
      else
        raise ArgumentError, "Invalid fullfilment status"
      end
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
      orders << line
    end
    return orders
  end
  # def sort_order
  #   order = []
  #   self.all.each do |item|
  #    order = item[1].split(';')

  #   end

  def self.find(id)
    self.all.each do |item|
      if item[0] == "#{id}"
        return item
      end
    end
    raise ArgumentError, "This order is not in the list."
  end
end

ap Order.all
